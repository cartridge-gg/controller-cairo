# Controller Accounts on Starknet

A flexible smart contract account system with session keys, multi-owner support and advanced authentication features.

## Overview

Controller Accounts implement a flexible account system with multi-owner support. The current implementation features:

- **Multi-Owner Support**: Support for multiple owners with flexible authentication
- **Multiple Signer Types**: Support for Starknet native, Passkeys, EIP191, and Sign-In-With-Starknet signatures
- **Session Authentication**: Temporary session tokens for improved user experience
- **Outside Execution**: Sponsored transaction support from external contracts
- **External Owners**: Support for external contract addresses as owners
- **Delegate Account**: Account delegation functionality
- **Upgradeable**: Safe contract upgrade mechanism

**Note**: Guardian-based security and recovery mechanisms are planned features but not currently implemented in this version.

## Specification

See [Controller Account](./docs/controller_account.md) for detailed specifications.

## Development

### Setup

We recommend installing scarb through ASDF. Please refer to [these instructions](https://docs.swmansion.com/scarb/download.html#install-via-asdf).

Thanks to the [.tool-versions file](./.tool-versions), you don't need to install specific versions. The correct versions will be automatically downloaded:
- Scarb 2.11.1
- Starknet Foundry 0.40.0

### Testing

```bash
scarb test
```

### Code Quality

```bash
scarb fmt        # Format code
scarb lint       # Run linter
```

### Building

```bash
scarb build      # Build contracts
```

### Deployment

```bash
# Set up your .env file (see .env.example)
scarb run deploy-account
```

## Project Structure

- `src/presets/` - Main Controller Account implementation
- `src/account/`, `src/multisig/` - Core account interfaces and logic  
- `src/signer/` - Multiple signature type support (Starknet, Passkeys, EIP191, SIWS)
- `src/session/` - Session-based authentication
- `src/multiple_owners/` - Multi-owner management
- `src/external_owners/` - External contract owner support
- `src/delegate_account/` - Account delegation functionality
- `src/outside_execution/` - Sponsored transaction support
- `src/recovery/`, `src/external_recovery/` - Recovery mechanisms (interface only, not implemented)
- `src/utils/` - Shared utilities
- `tests/` - Comprehensive test suite
- `docs/` - Detailed documentation

## Documentation

- [Controller Account Specification](./docs/controller_account.md)
- [Signers and Signatures](./docs/signers_and_signatures.md)
- [Sessions](./docs/sessions.md)
- [Outside Execution](./docs/outside_execution.md)
- [Account Upgrades](./docs/controller_account_upgrades.md)
- [Changelog](./docs/CHANGELOG_controller_account.md)

## Interface IDs

For compatibility reasons we support legacy interface IDs. New interface IDs follow [SNIP-5](https://github.com/starknet-io/SNIPs/blob/main/SNIPS/snip-5.md#how-interfaces-are-identified).

Tool to calculate interface IDs: https://github.com/ericnordelo/src5-rs

## Security Audits

This project has undergone multiple security audits. See the `audit/` directory for detailed reports.

## Release Checklist

- [ ] Bump version if needed (new deployment in mainnet)
- [ ] Set up your .env file with deployer info and run `scarb run deploy-account` to declare the account
- [ ] Verify the contracts if possible
- [ ] Deploy to multiple environments: mainnet, sepolia, and integration
- [ ] Create release in GitHub if needed
- [ ] Update documentation if there are breaking changes
- [ ] Make this checklist better if you learned something during the process
