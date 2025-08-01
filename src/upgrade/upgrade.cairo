use controller::account::interface::SRC5_ACCOUNT_INTERFACE_ID;
use starknet::ClassHash;
use starknet::syscalls::replace_class_syscall;

#[starknet::interface]
trait IUpgradeInternal<TContractState> {
    fn complete_upgrade(ref self: TContractState, new_implementation: ClassHash);
}

#[starknet::component]
mod upgrade_component {
    use controller::account::interface::SRC5_ACCOUNT_INTERFACE_ID;
    use controller::introspection::interface::{ISRC5DispatcherTrait, ISRC5LibraryDispatcher};
    use controller::upgrade::interface::{
        IUpgradableCallback, IUpgradableCallbackDispatcherTrait, IUpgradableCallbackLibraryDispatcher, IUpgradeable,
    };
    use controller::utils::asserts::assert_only_self;
    use starknet::ClassHash;
    use starknet::syscalls::replace_class_syscall;

    #[storage]
    struct Storage {}

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        AccountUpgraded: AccountUpgraded,
    }

    /// @notice Emitted when the implementation of the account changes
    /// @param new_implementation The new implementation
    #[derive(Drop, starknet::Event)]
    struct AccountUpgraded {
        new_implementation: ClassHash,
    }

    #[embeddable_as(UpgradableImpl)]
    impl Upgradable<
        TContractState, +HasComponent<TContractState>, +IUpgradableCallback<TContractState>,
    > of IUpgradeable<ComponentState<TContractState>> {
        fn upgrade(ref self: ComponentState<TContractState>, new_implementation: ClassHash, data: Array<felt252>) {
            assert_only_self();
            let supports_interface = ISRC5LibraryDispatcher { class_hash: new_implementation }
                .supports_interface(SRC5_ACCOUNT_INTERFACE_ID);
            assert(supports_interface, 'ctrl/invalid-implementation');
            IUpgradableCallbackLibraryDispatcher { class_hash: new_implementation }
                .perform_upgrade(new_implementation, data.span());
        }
    }

    #[embeddable_as(UpgradableInternalImpl)]
    impl UpgradableInternal<
        TContractState, +HasComponent<TContractState>,
    > of super::IUpgradeInternal<ComponentState<TContractState>> {
        fn complete_upgrade(ref self: ComponentState<TContractState>, new_implementation: ClassHash) {
            replace_class_syscall(new_implementation).expect('ctrl/invalid-upgrade');
            self.emit(AccountUpgraded { new_implementation });
        }
    }
}
