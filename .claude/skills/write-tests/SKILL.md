---
name: write-tests
description: Write tests using Starknet Foundry following project conventions
---

## Testing with Starknet Foundry

### Running Tests

```bash
scarb test                    # Run all tests
scarb test <test_name>        # Run specific test
snforge test                  # Alternative command
```

### Test File Structure

Tests are in `tests/` directory:
- `tests/setup/` - Test utilities and setup helpers
- `tests/test_*.cairo` - Test files (prefix with `test_`)
- `tests/lib.cairo` - Module declarations

### Writing Tests

**Basic Test:**
```cairo
#[test]
fn test_my_feature() {
    // Arrange
    let value = 5;
    
    // Act
    let result = my_function(value);
    
    // Assert
    assert(result == expected, 'unexpected result');
}
```

**Test with Expected Failure:**
```cairo
#[test]
#[should_panic(expected: 'error message')]
fn test_should_fail() {
    // Code that should panic
}
```

### Test Setup Utilities

This project provides setup helpers in `tests/setup/`:

**Account Setup** (`account_test_setup.cairo`):
```cairo
use tests::setup::account_test_setup::{
    deploy_controller_account,
    // other helpers
};
```

**Constants** (`constants.cairo`):
```cairo
use tests::setup::constants::{
    OWNER,
    // other test constants
};
```

**Utilities** (`utils.cairo`):
```cairo
use tests::setup::utils::{
    // helper functions
};
```

### Starknet Foundry Features

**Cheatcodes:**
```cairo
use snforge_std::{
    start_cheat_caller_address,
    stop_cheat_caller_address,
    start_cheat_block_timestamp,
    spy_events,
    // etc.
};

#[test]
fn test_with_cheatcodes() {
    let contract_address = deploy_contract();
    
    // Spoof caller
    start_cheat_caller_address(contract_address, OWNER());
    
    // Make call as OWNER
    contract.do_something();
    
    stop_cheat_caller_address(contract_address);
}
```

**Event Testing:**
```cairo
#[test]
fn test_events() {
    let mut spy = spy_events();
    
    // Trigger event
    contract.do_something();
    
    // Assert event was emitted
    spy.assert_emitted(@array![
        (contract_address, Event::MyEvent(MyEvent { value: 42 }))
    ]);
}
```

### Test Organization

**Group related tests:**
```cairo
mod test_feature_x {
    #[test]
    fn test_basic_case() { }
    
    #[test]
    fn test_edge_case() { }
    
    #[test]
    #[should_panic]
    fn test_invalid_input() { }
}
```

### Naming Conventions

- Test files: `test_<feature>.cairo`
- Test functions: `test_<what_is_tested>`
- Setup functions: `setup_<what>` or `deploy_<contract>`

### Common Patterns in This Project

**Testing Signatures:**
```cairo
// See tests/test_argent_account_signatures.cairo
// for signature verification test patterns
```

**Testing Multisig:**
```cairo
// See tests/test_multisig_*.cairo
// for multisig-related test patterns
```

**Testing Components:**
```cairo
// See tests/test_comp_*.cairo
// for component testing patterns
```
