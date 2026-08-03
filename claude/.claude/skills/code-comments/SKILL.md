---
name: code-comments
description: >
  Write and maintain high-value code comments during non-trivial implementation,
  refactoring, and debugging. Use in code review to assess comment quality
  without editing unless changes are authorized. Documents contracts, design
  decisions, non-obvious rationale, domain knowledge, and dense execution flows
  while removing stale, trivial, or unjustified commented-out code from the
  authorized scope.
---

# Write comments for future readers

A useful comment supplies context the code cannot express or materially lowers
the effort required to understand it. Comments are part of the implementation
and must remain true as the code evolves.

## Respect the task's authority

Choose the operating mode before acting:

| Request                                | Comment edits                       | Source, design, or test edits                     |
| -------------------------------------- | ----------------------------------- | ------------------------------------------------- |
| Implementation, refactor, or debugging | Allowed inside the authorized scope | Allowed only as required by the task              |
| Comment maintenance                    | Allowed inside the named scope      | Report other defects unless explicitly authorized |
| Code review or audit                   | Read-only; report findings          | Read-only                                         |

Do not turn a review into an editing pass. Do not widen a comment-only request
into behavioral changes, refactoring, assertions, or tests. If writing an
accurate comment exposes an implementation defect outside the authorized scope,
report it instead of silently fixing it.

## Ground rules

1. Read applicable repository guidance and two or three neighboring files.
   Project rules, generated-doc requirements, and language conventions override
   this skill.
2. Understand the behavior before explaining it. Investigate tests, callers,
   history, and nearby code rather than fossilizing a guess.
3. Prefer names, types, APIs, assertions, and tests for facts they can enforce.
   Use comments for contracts, rationale, context, and cognitive guidance.
4. Keep a comment beside the smallest code region it governs. Update or remove
   it when that code or its assumptions change.
5. Do not rewrite unrelated comments merely to impose a preferred style.
6. Write new prose in clear English while preserving identifiers, protocol
   terms, quotations, and required vocabulary.

## Decide whether a comment earns its cost

Ask:

1. What question will a future reader have—contract, rationale, domain concept,
   ordering, state, ownership, or high-level orientation?
2. Can the code answer it more reliably through a better name, type, structure,
   assertion, or test?
3. What is the smallest scope the explanation governs?
4. Will reading the comment cost less than reconstructing the fact?
5. What could make it stale, and can it be phrased around a durable constraint?

Obvious code may still need a comment when understanding it requires hidden
state, external domain knowledge, or simulation of a long sequence. Unusual
code does not deserve a speculative explanation when its real reason is unknown.

## Write the right kind of comment

### Contracts

Document public APIs and complex internal units as black boxes. Include only the
applicable details:

- purpose and abstraction;
- input meaning, units, ownership, ranges, and preconditions;
- return value, postconditions, errors, and partial success;
- externally visible side effects; and
- concurrency, cancellation, lifetime, or retry guarantees.

Do not translate a signature into prose or repeat types already visible in
generated documentation.

```rust
/// Advances to the first record newer than `watermark`.
///
/// The cursor remains unchanged if loading the next page fails, so callers may
/// retry without skipping records.
fn advance_after(&mut self, watermark: Sequence) -> Result<bool, Error> {
    // ...
}
```

### Design and rationale

Explain constraints, shared invariants, meaningful rejected alternatives, and
why a tempting simpler implementation would be wrong. Place a design comment at
the start of the module or section it governs; place a why comment immediately
beside the surprising decision.

For regression-sensitive logic, state the concrete failure sequence rather than
who changed it or when:

```rust
// Advance before processing. If this shard consumes the time budget, the next
// pass must start elsewhere instead of starving every later shard.
next_shard = (next_shard + 1) % shards.len();
```

When the task authorizes test changes, enforce the invariant with a test as well.
The comment explains why it matters; the test prevents regression.

### Domain and execution guidance

Teach only the protocol, mathematics, storage layout, ownership rule, or other
domain knowledge needed for the code below. Use a small example, equation, state
diagram, or stable primary-source link when it saves explanation.

Guide comments may label meaningful phases or expose hard-to-simulate state in a
dense flow. They should not decorate every few lines. Prefer a well-named helper
when extraction improves clarity without destroying useful locality.

```c
lua_gettable(lua, -2);  /* Stack: request, table, handler */
lua_pushvalue(lua, -3); /* Stack: request, table, handler, request */
```

## Remove low-value commentary

### Trivial narration

Delete comments that merely restate the next expression, assignment, branch, or
function name.

```text
Bad:  // Return the cached value.
      return cached_value;

Good: // Keep serving the last successful value while refresh is in flight.
      return cached_value;
```

### Stale or speculative claims

Remove or rewrite comments that describe obsolete behavior, promise guarantees
the code does not provide, refer to renamed symbols, or guess at intent without
evidence.

### Debt markers

Retain `TODO`, `FIXME`, `XXX`, or “hack” comments only when they identify:

- the concrete remaining problem;
- why it is deferred; and
- the condition that should trigger revisiting it.

Do not invent owners, dates, tickets, or promises. Fix small debt only when the
current task authorizes it; otherwise report it or use the repository's issue
system.

### Commented-out code

Historical implementations belong in Git, not source comments. Remove
commented-out code within the authorized scope. A narrow exception is a
temporary external blocker documented with the condition for reactivation or
removal; prefer a feature flag, platform guard, fixture, or example when it
expresses the constraint safely.

## Use comment writing as an analysis check

If a contract, rationale, or transition cannot be explained coherently, pause
and inspect the implementation. The difficulty may reveal accidental behavior,
an ambiguous postcondition, a coincidental invariant, misplaced responsibility,
or missing validation.

Fix it only when the task authorizes that change. Otherwise, report the defect
and avoid writing a confident but false explanation.

## Completion check

Within the authorized scope, confirm:

- comments match normal and error-path behavior;
- public and complex contracts expose the guarantees callers need;
- surprising ordering and durable constraints are explained;
- enforceable facts live in code or tests where authorized;
- debt markers are concrete and actionable;
- stale, redundant, and unjustified commented-out code is gone; and
- new prose follows repository syntax and language conventions.

Run the relevant documentation, formatting, lint, and test checks. Comment-only
changes can still break doctests, links, examples, or lint rules.
