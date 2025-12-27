---
name: write-cairo
description: Write Cairo code following the Cairo Book and project conventions
---

## Cairo Development Guide

### Reference

The Cairo Book: https://www.starknet.io/cairo-book/

### Project Conventions

**Formatting:**
- 120 character line limit
- Sorted module-level items (imports, declarations)
- Run `scarb fmt` before committing

**File Structure:**
- Interfaces in `interface.cairo` files
- Implementations in separate files
- Group related functionality in directories

### Core Cairo Patterns

**Variables and Types:**
```cairo
let x: felt252 = 5;           // Immutable by default
let mut y: u256 = 10;         // Mutable with 'mut'
let z: Option<felt252> = Option::Some(1);
```

**Functions:**
```cairo
fn function_name(param: Type) -> ReturnType {
    // implementation
}
```

**Structs and Traits:**
```cairo
#[derive(Drop, Serde, starknet::Store)]
struct MyStruct {
    field: felt252,
}

trait MyTrait<T> {
    fn my_method(self: @T) -> felt252;
}
```

### Starknet Contract Patterns

**Component Pattern** (used extensively in this project):
```cairo
#[starknet::component]
pub mod my_component {
    #[storage]
    struct Storage {
        value: felt252,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    pub enum Event {
        ValueChanged: ValueChanged,
    }

    #[derive(Drop, starknet::Event)]
    struct ValueChanged {
        new_value: felt252,
    }

    #[embeddable_as(MyComponentImpl)]
    impl MyComponent<
        TContractState, +HasComponent<TContractState>
    > of super::IMyComponent<ComponentState<TContractState>> {
        fn get_value(self: @ComponentState<TContractState>) -> felt252 {
            self.value.read()
        }
    }
}
```

**Embedding Components:**
```cairo
#[starknet::contract]
mod MyContract {
    component!(path: my_component, storage: my_storage, event: MyEvent);

    #[abi(embed_v0)]
    impl MyComponentImpl = my_component::MyComponent<ContractState>;
}
```

### Project-Specific Patterns

**Signer Types** (see `src/signer/`):
- `StarknetSigner` - Native Starknet signatures
- `Secp256k1Signer` - Ethereum-compatible (EIP191)
- `Secp256r1Signer` - WebAuthn/Passkeys
- `Eip191Signer` - EIP-191 signatures
- `WebauthnSigner` - Full WebAuthn support

**Storage Patterns:**
```cairo
// Use felt252 for simple values
value: felt252,

// Use LegacyMap for mappings
owners: LegacyMap<felt252, bool>,

// Use specialized storage types from utils
// See src/utils/array_store.cairo for array storage
```

### Error Handling

```cairo
// Use assert with error messages
assert(condition, 'error message');

// For recoverable errors, use Result/Option
fn may_fail() -> Result<felt252, felt252> {
    if condition {
        Result::Ok(value)
    } else {
        Result::Err('error')
    }
}
```

### Common Imports

```cairo
use starknet::{ContractAddress, get_caller_address, get_contract_address};
use starknet::storage::{StoragePointerReadAccess, StoragePointerWriteAccess};
use core::poseidon::poseidon_hash_span;
```
