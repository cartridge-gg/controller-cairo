use starknet::account::Call;
use starknet::{ContractAddress, get_caller_address, get_contract_address};

const DECLARE_SELECTOR: felt252 = selector!("__declare_transaction__");

#[inline(always)]
fn assert_only_self() {
    assert(get_contract_address() == get_caller_address(), 'ctrl/only-self');
}

#[inline(always)]
fn assert_only_protocol(caller_address: ContractAddress) {
    assert(caller_address.is_zero(), 'ctrl/non-null-caller');
}

fn assert_no_self_call(mut calls: Span<Call>, self: ContractAddress) {
    while let Option::Some(call) = calls.pop_front() {
        if *call.selector != DECLARE_SELECTOR {
            assert(*call.to != self, 'controller/no-multicall-to-self')
        }
    }
}
