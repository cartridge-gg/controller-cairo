---
name: review-code
description: Review Cairo smart contract code for security and best practices
---

## Code Review Checklist

### Security Checks

**Access Control:**
- [ ] Functions check caller authorization (`get_caller_address()`)
- [ ] Owner-only functions properly restricted
- [ ] Multi-sig requirements enforced where needed
- [ ] No unauthorized state modifications

**Signature Verification:**
- [ ] Signatures verified before executing sensitive operations
- [ ] Replay protection in place (nonces, unique hashes)
- [ ] Signature malleability considered
- [ ] All signer types handled correctly

**Arithmetic:**
- [ ] No overflow/underflow risks (Cairo handles this, but verify logic)
- [ ] Division by zero prevented
- [ ] Edge cases for zero values handled

**Reentrancy:**
- [ ] State updated before external calls
- [ ] Check-effects-interactions pattern followed
- [ ] Reentrant calls considered in design

**Storage:**
- [ ] Storage keys don't collide
- [ ] Mappings use appropriate key types
- [ ] Storage reads/writes are intentional

### Code Quality

**Formatting:**
- [ ] 120 character line limit respected
- [ ] Consistent naming conventions
- [ ] Proper indentation
- [ ] Run `scarb fmt` to verify

**Structure:**
- [ ] Functions are focused (single responsibility)
- [ ] Complex logic broken into helper functions
- [ ] Interfaces properly defined
- [ ] Events emitted for state changes

**Documentation:**
- [ ] Public functions documented
- [ ] Complex logic explained
- [ ] Edge cases noted

### Smart Contract Specifics

**Upgradeability:**
- [ ] Upgrade functions properly protected
- [ ] State migration considered
- [ ] No storage layout conflicts

**Gas Efficiency:**
- [ ] Avoid unnecessary storage reads/writes
- [ ] Batch operations where possible
- [ ] Consider calldata size

**Error Handling:**
- [ ] Descriptive error messages
- [ ] Fail early with clear assertions
- [ ] No silent failures

### Component-Specific Reviews

**For Signer Components:**
- [ ] All signer types validated correctly
- [ ] GUID calculation consistent
- [ ] Signature format matches specification

**For Session Components:**
- [ ] Session expiration checked
- [ ] Method restrictions enforced
- [ ] Revocation works correctly

**For Outside Execution:**
- [ ] Caller authorization verified
- [ ] Signature covers all execution parameters
- [ ] Replay protection active

### Testing Coverage

- [ ] Happy path tested
- [ ] Edge cases covered
- [ ] Error conditions tested (`#[should_panic]`)
- [ ] Events verified
- [ ] All public functions have tests

### Common Issues to Watch For

1. **Missing access control** - Always verify caller permissions
2. **Incorrect hash computation** - Verify hash inputs match spec
3. **Storage collision** - Component storage must not overlap
4. **Unchecked external calls** - Validate return values
5. **Hardcoded values** - Use constants or configuration
6. **Missing events** - State changes should emit events
