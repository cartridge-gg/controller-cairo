---
name: update-pr
description: Update existing pull requests based on review feedback
---

## Updating Pull Requests

### Responding to Review Feedback

1. **Read all comments** before making changes
2. **Address each comment** - either fix or explain why not
3. **Re-run checks** after making changes

### Making Changes

**For small fixes** (typos, minor adjustments):
```bash
# Make changes, then amend the last commit
git add -A
git commit --amend --no-edit
git push --force-with-lease
```

**For significant changes** (new logic, multiple files):
```bash
# Create a new commit with descriptive message
git add -A
git commit -m "fix: address review feedback - <specific change>"
git push
```

### When to Amend vs New Commit

**Amend when:**
- Fixing typos or formatting
- Small adjustments to the same logical change
- Pre-commit hooks auto-modified files

**New commit when:**
- Adding new functionality based on feedback
- Making substantial changes to approach
- Changes that warrant their own description

### Re-running Checks

After pushing updates:
```bash
make lint-check  # Verify formatting and build
scarb test       # Run all tests
```

### Responding to Comments

Use GitHub's "Resolve conversation" feature after addressing each comment.

For comments you disagree with:
- Explain your reasoning clearly
- Reference documentation or prior decisions if applicable
- Be open to discussion

### Updating PR Description

If the scope changed significantly:
```bash
gh pr edit <PR_NUMBER> --body "$(cat <<'EOF'
## Summary
<updated description>

## Changes
- <updated changes>

## Testing
- <updated testing notes>
EOF
)"
```

### Force Push Safety

Always use `--force-with-lease` instead of `--force`:
```bash
git push --force-with-lease
```

This prevents accidentally overwriting commits pushed by others.
