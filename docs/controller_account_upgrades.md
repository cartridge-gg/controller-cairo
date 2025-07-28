# Controller Account Upgrades

This document covers the upgrade process for Controller Accounts.

## Current Version: 0.4.0

The current version is 0.4.0, which includes significant improvements and breaking changes. See the [changelog](./CHANGELOG_controller_account.md) for detailed information about what's new.

## Upgrade Principles

- **No Downgrading**: Downgrading is not supported and is actively prevented from version 0.4.0 onwards
- **Secure Process**: Upgrades require approval from both owner and guardian signatures
- **Escape Handling**: Some upgrades may cancel ongoing escapes, which can be re-triggered after upgrade completion
- **Bundle Support**: Version 0.3.0+ supports bundling upgrades with multicalls (with restrictions)

## Upgrade Process

To upgrade a Controller Account:

1. Ensure you have both owner and guardian signatures available
2. Prepare any post-upgrade calls (if bundling operations)
3. Call the `upgrade` function with the new class hash
4. The system will automatically handle migration logic

### Bundled Upgrades (v0.3.0+)

You can bundle additional operations with upgrades by serializing calls as `Array<Call>` and passing them to `upgrade`. 

**Restriction**: Bundled calls cannot make calls back to the account itself.

## Legacy Upgrade Paths

### From v0.2.3.* to >=0.3.0

**⚠️ WARNING ⚠️** When upgrading from v0.2.3.*, you must pass non-empty `calldata` to the upgrade method.

The legacy upgrade function signature was:
```cairo
func upgrade(implementation: felt, calldata_len: felt, calldata: felt*)
```

If `calldata_len` is 0, the proxy won't be properly removed and the account will malfunction. Always pass at least an empty array.

### From versions < 0.2.3

A two-step upgrade is required:
1. First upgrade to v0.2.3.1
2. Then upgrade to the target version

## Version 0.4.0 Breaking Changes

- **No Downgrades**: Cannot downgrade from 0.4.0 to any older version
- **Signer Type Changes**: Many functions now use `Signer` types instead of raw public keys
- **Multi-Owner System**: Simplified to basic owner management (guardian/recovery features not implemented)
- **Component Architecture**: Modular design with separate components for different features

**Note**: Guardian-based security and recovery mechanisms described in legacy documentation are not implemented in the current version.

For detailed migration information, see the [changelog](./CHANGELOG_controller_account.md).
