use controller::offchain_message::interface::{
    IOffChainMessageHashRev1, IStructHashRev1, StarkNetDomain, StarknetDomain, StructHashStarkNetDomain,
};
use controller::offchain_message::precalculated_hashing::get_message_hash_rev_1_with_precalc;
use controller::outside_execution::interface::OutsideExecution;
use hash::{HashStateExTrait, HashStateTrait};
use pedersen::PedersenTrait;
use poseidon::{HashState, hades_permutation, poseidon_hash_span};
use starknet::account::Call;
use starknet::{get_contract_address, get_tx_info};

const MAINNET_FIRST_HADES_PERMUTATION: (felt252, felt252, felt252) = (
    996915192477314844232397706210079185628598843828924621070706959145689833980,
    2154834376955455672602400038844399406202405733270731961376124532261347854986,
    1129673910579930509220015777859527444962253764479830284363060876794734318472,
);

const SEPOLIA_FIRST_HADES_PERMUTATION: (felt252, felt252, felt252) = (
    2648373253270285159769360603517540536782489473878572730211506916518063798474,
    604219299452944139991089465374505793098487122536238208890268251872611859633,
    2075519913841617027120337084019352091900417009471098949739064814802390776233,
);

const OUTSIDE_EXECUTION_TYPE_HASH_REV_2: felt252 = selector!(
    "\"OutsideExecution\"(\"Caller\":\"ContractAddress\",\"Nonce\":\"(felt,u128)\",\"Execute After\":\"u128\",\"Execute Before\":\"u128\",\"Calls\":\"Call*\")\"Call\"(\"To\":\"ContractAddress\",\"Selector\":\"selector\",\"Calldata\":\"felt*\")",
);

const CALL_TYPE_HASH_REV_2: felt252 = selector!(
    "\"Call\"(\"To\":\"ContractAddress\",\"Selector\":\"selector\",\"Calldata\":\"felt*\")",
);

impl StructHashCallRev2 of IStructHashRev1<Call> {
    fn get_struct_hash_rev_1(self: @Call) -> felt252 {
        poseidon_hash_span(
            array![CALL_TYPE_HASH_REV_2, (*self.to).into(), *self.selector, poseidon_hash_span(*self.calldata)].span(),
        )
    }
}

impl StructHashOutsideExecutionRev2 of IStructHashRev1<OutsideExecution> {
    fn get_struct_hash_rev_1(self: @OutsideExecution) -> felt252 {
        let self = *self;
        let mut calls_span = self.calls;
        let mut hashed_calls = array![];

        while let Option::Some(call) = calls_span.pop_front() {
            hashed_calls.append(call.get_struct_hash_rev_1());
        }

        let (nonce_channel, nonce_mask) = self.nonce;

        poseidon_hash_span(
            array![
                OUTSIDE_EXECUTION_TYPE_HASH_REV_2,
                self.caller.into(),
                nonce_channel,
                nonce_mask.into(),
                self.execute_after.into(),
                self.execute_before.into(),
                poseidon_hash_span(hashed_calls.span()),
            ]
                .span(),
        )
    }
}

impl OffChainMessageOutsideExecutionRev2 of IOffChainMessageHashRev1<OutsideExecution> {
    fn get_message_hash_rev_1(self: @OutsideExecution) -> felt252 {
        // Version is a felt instead of a shortstring in SNIP-9 due to a mistake in the Braavos
        // contracts and has been copied for compatibility.
        // Revision will also be a felt instead of a shortstring for all SNIP22-rev2 signatures
        // because of the same issue

        let chain_id = get_tx_info().unbox().chain_id;
        if chain_id == 'SN_MAIN' {
            return get_message_hash_rev_1_with_precalc(MAINNET_FIRST_HADES_PERMUTATION, *self);
        }
        if chain_id == 'SN_SEPOLIA' {
            return get_message_hash_rev_1_with_precalc(SEPOLIA_FIRST_HADES_PERMUTATION, *self);
        }
        let domain = StarknetDomain { name: 'Account.execute_from_outside', version: 2, chain_id, revision: 2 };
        poseidon_hash_span(
            array![
                'StarkNet Message',
                domain.get_struct_hash_rev_1(),
                get_contract_address().into(),
                (*self).get_struct_hash_rev_1(),
            ]
                .span(),
        )
    }
}

