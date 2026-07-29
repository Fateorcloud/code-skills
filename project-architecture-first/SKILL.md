---
name: project-architecture-first
description: >-
  use this skill when acting as codex or a coding agent for medium or large software projects, rewrites, refactors, migrations, documentation-heavy builds, or ambiguous feature requests. triggers include requests to start a project, reorganize a repository, split modules, define interfaces, plan implementation, manage shared state, write project docs, or make multi-step code changes. enforce architecture-first planning before implementation: define modules, interfaces, state ownership, test checkpoints, and change reports so each step is reviewable, executable, reversible, and easy for ai agents to continue.

---

# Project Architecture First

Use this skill to keep large coding work structured. The default behavior is to stop uncontrolled implementation drift by freezing architecture, module boundaries, interface contracts, state ownership, and test checkpoints before making broad code changes.

For detailed document templates, load `references/templates.md` when the user asks for full project documents or when the task needs files such as `PROJECT_ARCHITECTURE.md`, `MODULES.md`, `INTERFACES.md`, `STATE_MODEL.md`, `TEST_PLAN.md`, or `CHANGE_REPORT.md`.

## Operating Principles

1. Prefer architecture before detail. Do not jump into implementation for medium or large work until the architecture, modules, interfaces, and state model are explicit.
2. Keep each step independently testable. Every planned step must include a validation command, manual check, or reason why no test can run.
3. Make agent work resumable. Record assumptions, changed files, decisions, tests, and next steps after each meaningful change.
4. Reduce hidden coupling. Access shared state only through declared interfaces. Avoid scattered writes and implicit global mutation.
5. Write for the next agent. Use clear names, compact comments for non-obvious decisions, and small change reports so another Codex run can continue safely.

## Scope Classification

Before acting, classify the request:

- **small**: one isolated bug, one file, or a clear local edit. Proceed directly, but still summarize the change and test result.
- **medium**: multiple files, a new feature, or unclear dependencies. Create a short architecture plan before editing.
- **large**: new project, major refactor, migration, framework change, or many modules. Produce architecture documents first and ask for confirmation when the implementation direction is materially uncertain.

If the user explicitly asks to skip planning, keep a minimal version: module map, state owner, test checkpoint, and change report.

## Default Workflow

### 1. Intake and Inventory

Collect only the missing information needed to avoid wrong architecture. Inspect the repository before proposing structure when files are available.

Capture:

- product goal and non-goals
- runtime/framework/language constraints
- existing repository structure
- external services, persistence, auth, jobs, and deployment assumptions
- user-visible behavior and success criteria
- risks, unknowns, and decisions requiring user confirmation

### 2. Architecture Skeleton

Create a concise architecture skeleton before writing implementation details. It must include:

- system purpose in one paragraph
- major modules and responsibilities
- dependency direction between modules
- public interfaces between modules
- state ownership model
- data flow for the primary user journey
- test strategy and rollback points

For a large project, write or update `PROJECT_ARCHITECTURE.md` first.

### 3. Module Plan

For each module, define:

- responsibility and explicit non-responsibilities
- owned files or directories
- dependencies allowed and dependencies forbidden
- inputs, outputs, and side effects
- state read/write permissions
- tests that prove the module works

A module should have one reason to change. If a module owns too many responsibilities, split it before implementation.

### 4. Interface Contracts

Define interfaces before implementation. Each interface should state:

- caller and callee
- purpose
- function, command, event, endpoint, or class name
- input schema or parameters
- output schema or return value
- errors and failure behavior
- side effects
- state read/write permissions
- compatibility notes
- test cases or contract checks

Do not let implementation code bypass declared interfaces to reach internal state.

### 5. State Model

Make mutable state explicit and atomic.

Use these rules:

- Assign each state value exactly one owner.
- Prefer one write path per state value.
- Other modules read state through queries/selectors and request changes through commands/events.
- Keep derived state derived; do not persist it unless there is a clear performance or audit reason.
- Document invariants and transitions.
- Avoid hidden shared mutable globals.

State documentation should answer: where is the source of truth, who may write it, who may read it, what transitions are allowed, and how it is tested.

### 6. Implementation Slices

Work in small vertical slices. Each slice must have:

- goal
- files to change
- interface or state contract touched
- test or validation command
- rollback note
- expected user-visible result

After each slice, run available tests or explain why they cannot be run.

### 7. Change Report

After every meaningful implementation step, produce a compact change report:

- what changed
- why it changed
- files touched
- tests run and result
- interface or state impact
- risks and follow-up
- next recommended step

Do not bury change reports in long prose. Keep them easy to scan.

## Codex-Specific Behavior

When acting in a codebase:

- Inspect before editing. Read relevant files, package scripts, tests, and docs before proposing broad changes.
- Prefer minimal, coherent patches over large speculative rewrites.
- Preserve existing conventions unless there is a documented reason to change them.
- Run the narrowest useful tests first, then broader tests if time permits.
- Never claim tests passed unless they actually ran.
- If tests fail, report the exact failure and whether it appears related to the change.
- Keep generated documentation close to the code it describes.
- Add comments only for non-obvious design decisions, invariants, or boundary rules.

## Default Output Files

Use these names when the user asks for project docs or when the project is large enough to benefit from persistent planning artifacts:

- `PROJECT_ARCHITECTURE.md`: system overview, dependency direction, data flow, decisions
- `MODULES.md`: module responsibilities, boundaries, dependencies
- `INTERFACES.md`: contracts between modules and external systems
- `STATE_MODEL.md`: source of truth, allowed transitions, ownership, invariants
- `TEST_PLAN.md`: validation strategy and per-slice checks
- `CHANGE_REPORT.md`: implementation log and next steps

For smaller work, inline the same structure in the response instead of creating files.

## Quality Gates

Before implementation, verify:

- Every major module has a clear responsibility.
- Every cross-module interaction has an interface.
- Every mutable state value has one owner.
- Every implementation slice has a validation step.
- The next step can be done without rereading the whole conversation.

Before final response, verify:

- The architecture and implementation are still aligned.
- Tests or validation results are honestly reported.
- The user can see what changed and what remains.
