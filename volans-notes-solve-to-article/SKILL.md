---
name: volans-notes-solve-to-article
description: Turn knowledge from the current conversation into one or more reviewed Volans Notes articles, then publish only after explicit confirmation. Use after solving a bug, designing or deploying something, completing a reproducible setup, learning a concept, or when the user asks what from the conversation is worth preserving as an article.
---

# Volans Notes Solve-To-Article

Distill reusable knowledge from the current conversation into local drafts. Never publish before the user reviews the draft and explicitly confirms.

## Target repository

Always write to the Volans Notes repository, even when invoked from another project:

```text
E:\Code_file\Volans_notes_1.0
```

If that path is unavailable, ask for the current repository path. Do not create the article in the current project.

Before drafting, read from the target repository:

```text
CONVENTION.md
CHECKLIST.md
docs/architecture/CONTENT_AUTHORING.md
```

## Workflow

1. Scan the conversation for verified, reusable conclusions. Separate distinct concepts; do not combine unrelated material to make one large article.
2. Apply the placement decision in `CONVENTION.md`. Keep project progress in its project journal, unstable material in drafts, and stable concept relationships in LLM_Wiki. Do not force every conversation into Posts.
3. If there are several article candidates, list each with a one-line thesis, proposed placement, category, optional series, and writing archetype. Ask which candidates to draft. If there is one clear candidate, state it and continue. If evidence is insufficient, explain what is missing and stop.
4. Draft only the selected candidates. Use one main question or conclusion per file and choose the closest documented archetype.
5. Preserve evidence from the conversation. Cite concrete commands, logs, run names, or decisions where available. Mark unsupported claims as `TODO(source: ...)`; never invent results or credentials.
6. Write `drafts/<slug>.md` with a matching lowercase kebab-case slug, real dates, required category, optional registered series, and `status: "draft"`.
7. Run from the Volans Notes repository:

   ```powershell
   pnpm article:check --file drafts/<slug>.md
   ```

8. Report the draft path, placement, archetype, category/series, outline, source evidence, validation result, and open TODOs. Stop for review.
9. Publish only after the user has seen that draft and explicitly says “上线”, “发布”, “publish”, or “go”. A request to revise, continue writing, or make it better is not publication approval.
10. After approval, run the supported flow for each approved article:

    ```powershell
    pnpm article:publish --slug <slug> --visibility public|admin --file drafts/<slug>.md
    pnpm content:validate
    pnpm test
    pnpm typecheck
    pnpm build
    pnpm test:leaks
    ```

    Commit/push, wait for deployment, and smoke-check the live URL only when the approval includes going live. Report every command result accurately.

## Boundaries

- Do not handle withdraw or republish. Point the user to the terminal runbook in `infra/deployment/ADMIN_OPERATIONS.md`.
- Do not bypass `content/visibility-registry.json` or edit publication history manually.
- Do not include tokens, private keys, cookies, or sensitive operational details.
- Do not claim inaccessible evidence was verified.

## Review output

```text
Draft ready (not published): <absolute draft path>
Placement / archetype: <placement> / <archetype>
Category / series: <category> / <series or none>
Evidence: <conversation sources>
Validation: pnpm article:check -> <result>
Open TODOs: <items or none>
Next: review the draft; say 上线/发布 only when it is ready.
```

