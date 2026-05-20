---
name: address-stack-comments
description: Address PR review comments across an entire Graphite stack, starting from the bottom and working up. Use when user wants to handle feedback on a stacked set of PRs.
---

# Address PR Comments Across a Graphite Stack

Walk an entire Graphite stack bottom-to-top, addressing PR review comments on each branch autonomously.

## Context

We are working in a Graphite stack. Changes that appear "reverted" in a given branch are not actually reverted — they are isolated in upstack PRs. Do not treat upstack diffs as regressions or missing code. Each branch only contains the changes relevant to its own PR.

## Workflow

1. Navigate to the bottom of the stack:

```bash
gt bottom
```

2. On the current branch, read each PR comment via `gh` and address it. **Do not prompt the user for approval** — evaluate each comment and take the action you believe is best.

3. After addressing all comments on the current branch, absorb changes and move up. Only amend if files were actually modified — skip `gt m -a` when no changes were made to avoid unnecessary hash rewrites and CI churn:

```bash
# If changes were made:
gt m -a && gt up
# If no changes were made:
gt up
```

4. Repeat steps 2–3 until `gt up` reports that you are already at the top of the stack (no more upstack branches).

5. When done with all branches, submit the full stack:

```bash
gt ss
```

## Addressing comments on a single branch

For each branch:

1. Read the full diff of the current branch's PR.
2. Fetch unresolved comments using `gh`.
3. If there are no unresolved comments, skip to the next branch.
4. For each comment, read the referenced code and evaluate:
   - Is this problem already handled elsewhere (possibly in an upstack PR)?
   - Is this comment overkill for this context?
   - Is it a valid concern that needs fixing?
5. Take action autonomously for each comment — do ONE of:
   - **Valid concern**: make the fix, then resolve the thread.
   - **Already handled upstack**: reply explaining which upstack PR handles it, then resolve.
   - **Not valid / non-blocking**: resolve.

## Response style

Keep replies short and direct. No fluff.