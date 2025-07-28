use controller::presets::controller_account::ControllerAccount::Owner;
use controller::recovery::interface::{EscapeStatus, LegacyEscape};
use controller::signer::signer_signature::{Signer, SignerSignature, SignerType};
use starknet::account::Call;

const SRC5_ACCOUNT_INTERFACE_ID: felt252 = 0x2ceccef7f994940b3962a6c67e0ba4fcd37df7d131417c604f91e03caecc1cd;
const SRC5_ACCOUNT_INTERFACE_ID_OLD_1: felt252 = 0xa66bd575;
const SRC5_ACCOUNT_INTERFACE_ID_OLD_2: felt252 = 0x3943f10f;

#[derive(Serde, Drop)]
struct Version {
    major: u8,
    minor: u8,
    patch: u8,
}

#[starknet::interface]
trait IAccount<TContractState> {
    fn __validate__(ref self: TContractState, calls: Array<Call>) -> felt252;
    fn __execute__(ref self: TContractState, calls: Array<Call>) -> Array<Span<felt252>>;

    /// @notice Checks whether a given signature for a given hash is valid
    /// @dev Warning: To guarantee the signature cannot be replayed in other accounts or other chains, the data hashed
    /// must be unique to the account and the chain.
    /// This is true today for starknet transaction signatures and for SNIP-12 signatures but might not be true for
    /// other types of signatures @param hash The hash of the data to sign
    /// @param signature The signature to validate
    /// @return The shortstring 'VALID' when the signature is valid, 0 if the signature doesn't match the hash
    /// @dev it can also panic if the signature is not in a valid format
    fn is_valid_signature(self: @TContractState, hash: felt252, signature: Array<felt252>) -> felt252;
}

#[starknet::interface]
trait IControllerAccount<TContractState> {
    fn __validate_declare__(ref self: TContractState, class_hash: felt252) -> felt252;
    fn __validate_deploy__(
        ref self: TContractState,
        class_hash: felt252,
        contract_address_salt: felt252,
        owner: Owner,
        guardian: Option<Signer>,
    ) -> felt252;
}

#[starknet::interface]
trait IAssertOwner<TState> {
    fn assert_owner(self: @TState);
}
