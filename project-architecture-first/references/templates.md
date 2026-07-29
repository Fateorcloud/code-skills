# Project Architecture First Templates

Load this file when the user wants persistent project documents or when a large Codex task needs a structured plan before implementation.

## PROJECT_ARCHITECTURE.md

```markdown
# Project Architecture

## Goal
What the project must accomplish.

## Non-goals
What this project intentionally will not solve.

## Constraints
- Language/framework:
- Runtime/deployment:
- Existing conventions:
- External systems:

## System Overview
Short description of the architecture.

## Dependency Direction
Describe which modules may depend on which other modules.

## Primary Data Flow
1. User/system action:
2. Entry point:
3. Module calls:
4. State read/write:
5. Output/result:

## Major Decisions
| Decision | Reason | Tradeoff |
|---|---|---|
|  |  |  |

## Risks and Unknowns
| Risk/Unknown | Impact | Resolution plan |
|---|---|---|
|  |  |  |
```

## MODULES.md

```markdown
# Modules

## Module: <name>

### Responsibility

### Non-responsibilities

### Owned files/directories

### Allowed dependencies

### Forbidden dependencies

### Inputs

### Outputs

### Side effects

### State permissions
- May read:
- May write:

### Tests
```

## INTERFACES.md

```markdown
# Interfaces

## Interface: <name>

### Caller

### Callee

### Purpose

### Type
Function, class, endpoint, command, event, queue message, file format, or other boundary.

### Input contract

### Output contract

### Errors and failure behavior

### Side effects

### State access
- Reads:
- Writes:

### Compatibility notes

### Contract tests
```

## STATE_MODEL.md

```markdown
# State Model

## State: <name>

### Source of truth

### Owner
Exactly one module or service.

### Readers

### Writer
Exactly one write path whenever possible.

### Allowed transitions
| From | To | Trigger | Validation |
|---|---|---|---|
|  |  |  |  |

### Invariants

### Derived state

### Persistence

### Tests
```

## TEST_PLAN.md

```markdown
# Test Plan

## Strategy

## Test commands
| Scope | Command | Expected result |
|---|---|---|
| unit |  |  |
| integration |  |  |
| lint/typecheck |  |  |

## Implementation slices
| Slice | Goal | Files | Validation | Rollback |
|---|---|---|---|---|
| 1 |  |  |  |  |

## Manual checks

## Known gaps
```

## CHANGE_REPORT.md

```markdown
# Change Report

## Step <n>: <short title>

### What changed

### Why

### Files touched

### Tests run
| Command/check | Result |
|---|---|
|  |  |

### Interface impact

### State impact

### Risks

### Next step
```

## Short Inline Plan Format

Use this when the task is medium-sized and persistent files would be overkill.

```markdown
## Architecture-first plan

### Modules
- `<module>`: responsibility, non-responsibility

### Interfaces
- `<interface>`: caller -> callee, input, output, failure behavior

### State
- `<state>`: owner, readers, writer, invariant

### Slices
1. Goal, files, validation, rollback

### Open questions
- Only questions that block safe implementation.
```
