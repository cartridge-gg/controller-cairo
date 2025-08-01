#[starknet::component]
mod src5_component {
    use controller::account::interface::{
        SRC5_ACCOUNT_INTERFACE_ID, SRC5_ACCOUNT_INTERFACE_ID_OLD_1, SRC5_ACCOUNT_INTERFACE_ID_OLD_2,
    };
    use controller::delegate_account::interface::SRC5_DELEGATE_ACCOUNT_INTERFACE_ID;
    use controller::external_owners::interface::SRC5_EXTERNAL_OWNERS_INTERFACE_ID;
    use controller::introspection::interface::{ISRC5, ISRC5Legacy, SRC5_INTERFACE_ID, SRC5_INTERFACE_ID_OLD};
    use controller::outside_execution::interface::ERC165_OUTSIDE_EXECUTION_INTERFACE_ID_REV_2;

    #[storage]
    struct Storage {}

    #[embeddable_as(SRC5Impl)]
    impl SRC5<TContractState, +HasComponent<TContractState>> of ISRC5<ComponentState<TContractState>> {
        fn supports_interface(self: @ComponentState<TContractState>, interface_id: felt252) -> bool {
            if interface_id == SRC5_INTERFACE_ID {
                true
            } else if interface_id == SRC5_ACCOUNT_INTERFACE_ID {
                true
            } else if interface_id == ERC165_OUTSIDE_EXECUTION_INTERFACE_ID_REV_2 {
                true
            } else if interface_id == SRC5_INTERFACE_ID_OLD {
                true
            } else if interface_id == SRC5_ACCOUNT_INTERFACE_ID_OLD_1 {
                true
            } else if interface_id == SRC5_ACCOUNT_INTERFACE_ID_OLD_2 {
                true
            } else if interface_id == SRC5_DELEGATE_ACCOUNT_INTERFACE_ID {
                true
            } else if interface_id == SRC5_EXTERNAL_OWNERS_INTERFACE_ID {
                true
            } else {
                false
            }
        }
    }

    #[embeddable_as(SRC5LegacyImpl)]
    impl SRC5Legacy<TContractState, +HasComponent<TContractState>> of ISRC5Legacy<ComponentState<TContractState>> {
        fn supportsInterface(self: @ComponentState<TContractState>, interfaceId: felt252) -> felt252 {
            if self.supports_interface(interfaceId) {
                1
            } else {
                0
            }
        }
    }
}
