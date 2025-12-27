---
name: create-pr
description: Create well-formed pull requests for this Cairo smart contract repository
---

## Creating Pull Requests

### Before Creating a PR

1. **Run all checks locally:**
   ```bash
   make lint-check  # Format and build check
   scarb test       # Run all tests
   ```

2. **Ensure your branch is up to date:**
   ```bash
   git fetch origin
   git rebase origin/main
   ```

### Commit Message Format

Use conventional commits:
- `feat:` New feature
- `fix:` Bug fix
- `refactor:` Code refactoring
- `docs:` Documentation changes
- `test:` Test additions or fixes
- `chore:` Maintenance tasks

Example: `feat: add session caching to reduce transaction costs`

### PR Title and Description

**Title**: Use the same format as commit messages (e.g., `feat: add multi-owner support`)

**Description template**:
```markdown
## Summary
Brief description of what this PR does and why.

## Changes
- List key changes
- One bullet per logical change

## Testing
- Describe how this was tested
- Reference specific test files if applicable

## Breaking Changes
List any breaking changes (if none, omit this section)
```

### Creating the PR

```bash
gh pr create --title "feat: your feature" --body "$(cat <<'EOF'
## Summary
<description>

## Changes
- <change 1>
- <change 2>

## Testing
- <how tested>
EOF
)"
```

### Checklist Before Submitting

- [ ] All tests pass (`scarb test`)
- [ ] Code is formatted (`scarb fmt`)
- [ ] Build succeeds (`scarb build`)
- [ ] No new warnings introduced
- [ ] Documentation updated if needed
- [ ] Changelog updated for user-facing changes
