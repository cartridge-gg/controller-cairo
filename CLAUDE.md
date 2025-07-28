# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Testing
- `scarb test` - Run all tests using Starknet Foundry
- `snforge test` - Alternative test command (same as above)
- `scarb test <test_name>` - Run specific test

### Code Quality
- `scarb fmt` - Format Cairo code according to project conventions
- `scarb run format` - Alternative format command
- `scarb run lint` - Run linter on the codebase

### Build
- `scarb build` - Build the Cairo contracts
- `scarb run deploy-account` - Deploy account contract (requires .env setup)

## Project Architecture

This is a **Cairo smart contract project** implementing Controller Accounts on Starknet - a flexible account system with multi-owner support and advanced authentication features.

### Core Architecture

**Main Contract**: `src/presets/controller_account.cairo`
- A Starknet account contract with flexible owner management
- Uses Cairo's component system with multiple embedded components for modularity

**Key Components**:
- `multiple_owners` - Manages multiple owners with simple ownership mapping
- `session` - Handles session-based authentication for improved UX
- `external_owners` - Support for external contract addresses as owners
- `outside_execution` - Enables sponsored transactions from external contracts
- `delegate_account` - Account delegation functionality
- `src5` - Standard interface introspection (SRC-5 compliant)
- `upgrade` - Contract upgradeability with OpenZeppelin components

**Note**: Recovery/escape mechanisms exist as interfaces but are not implemented in the current version.

### Current Implementation

The account supports:
- **Multi-owner authentication**: Multiple owners can control the account
- **Flexible signature verification**: Supports various signer types
- **Session tokens**: Temporary authentication for better user experience
- **External ownership**: Contract addresses can be owners
- **Sponsored transactions**: Outside execution support

### Directory Structure

- `src/presets/` - Main account implementation
- `src/account/`, `src/multisig/` - Core account interfaces and logic
- `src/signer/` - Multiple signature types (Starknet, Passkeys, EIP191, SIWS)
- `src/session/` - Session-based authentication system
- `src/multiple_owners/` - Multi-owner management
- `src/external_owners/` - External contract owner support
- `src/delegate_account/` - Account delegation functionality
- `src/outside_execution/` - Sponsored transaction support
- `src/recovery/`, `src/external_recovery/` - Recovery interfaces (not implemented)
- `src/utils/` - Shared utilities (hashing, serialization, calls, etc.)
- `src/mocks/` - Test mocks and utilities
- `tests/` - Comprehensive test suite

### Key Features

- **Multiple Signer Types**: Supports Starknet native, Passkeys (WebAuthn), EIP191, and Sign-In-With-Starknet
- **Session Authentication**: Temporary session tokens for improved UX
- **Multi-Owner Support**: Multiple owners can control the account
- **External Owners**: Contract addresses can be owners
- **Outside Execution**: Sponsored transaction support
- **Delegate Account**: Account delegation functionality
- **Upgradeable**: Safe contract upgrade mechanism
- **SRC-5 Compliant**: Standard interface introspection

### Development Notes

- Uses Scarb as the Cairo package manager
- Built with Cairo 2.11.1 and Starknet Foundry 0.40.0
- Includes comprehensive audit reports in `audit/` directory
- Extensive documentation in `docs/` covering all major features
- Code formatting enforces 120 character line limit and sorted module items