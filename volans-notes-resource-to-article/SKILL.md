---
name: volans-notes-resource-to-article
description: Inspect user-supplied documents, PDFs, Markdown, notes, webpages, links, videos, captions, or transcripts and turn them into a sourced, reviewed Volans Notes article, publishing only after explicit confirmation. Use when the user provides resources and asks to summarize, synthesize, explain, or convert them into a site article.
---

# Volans Notes Resource-To-Article

Turn supplied resources into a source-traceable local draft. Never summarize content that was not actually inspected, and never publish before review and explicit confirmation.

## Target repository

Always write to:

```text
E:\Code_file\Volans_notes_1.0
```

If unavailable, ask for the current Volans Notes path. Before drafting, read:

```text
CONVENTION.md
CHECKLIST.md
docs/architecture/CONTENT_AUTHORING.md
```

## Inspect the sources

- For local documents, PDFs, Markdown, text, images, or structured files, use the appropriate available file capability and inspect the relevant content rather than relying on filenames.
- For webpages and links, open the supplied URL and use the actual page as the source. Follow additional links only when needed for the requested article.
- For video, use accessible captions/transcripts or a transcript supplied by the user. If the content cannot be accessed, request a transcript or accessible copy; do not infer the video from its title, description, or thumbnail.
- For multiple sources, record agreements, conflicts, scope, and dates. Do not flatten conflicting claims into one unqualified statement.
- Track important claims back to filename/section, URL, quotation, or timestamp where practical.

## Workflow

1. Inventory the supplied resources and confirm which ones were successfully inspected. Identify missing or inaccessible evidence before drafting.
2. Apply the placement decision in `CONVENTION.md`. A stable concept map may belong in LLM_Wiki; a full project may be a Project; unverified material remains a draft. Do not force every resource into a Post.
3. State the proposed article's one main question or conclusion, target reader, category, optional series, and writing archetype. If the resources contain several independent articles, list candidates and ask which to draft.
4. Draft only the selected article(s). Separate source claims from synthesis, preserve meaningful citations, and mark unsupported statements as `TODO(source: ...)`.
5. Write `drafts/<slug>.md` with a matching lowercase kebab-case slug, real dates, required category, optional registered series, and `status: "draft"`.
6. Run:

   ```powershell
   pnpm article:check --file drafts/<slug>.md
   ```

7. Report the draft path, placement, archetype, category/series, source list, outline, validation result, and TODOs. Stop for user review.
8. Publish only after the user has seen the draft and explicitly says “上线”, “发布”, “publish”, or “go”. Revision requests are not publication approval.
9. After approval, run for each approved article:

   ```powershell
   pnpm article:publish --slug <slug> --visibility public|admin --file drafts/<slug>.md
   pnpm content:validate
   pnpm test
   pnpm typecheck
   pnpm build
   pnpm test:leaks
   ```

   Commit/push, wait for deployment, and smoke-check the live URL only when the approval includes going live. Report failures instead of skipping gates.

## Boundaries

- Do not handle withdraw or republish; direct those operations to `infra/deployment/ADMIN_OPERATIONS.md`.
- Do not bypass the registry or edit old publication history.
- Do not invent quotations, timestamps, benchmark values, deployment results, or credentials.
- Do not expose private resource content in a public article without explicit permission.

## Review output

```text
Draft ready (not published): <absolute draft path>
Placement / archetype: <placement> / <archetype>
Category / series: <category> / <series or none>
Sources inspected: <files/URLs/video transcript>
Validation: pnpm article:check -> <result>
Open TODOs: <items or none>
Next: review the draft; say 上线/发布 only when it is ready.
```

