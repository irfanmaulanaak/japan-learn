## Instructions
- CRITICAL: Use simple, concise language. Avoid overtechnical jargon.
- Be radically precise. No fluff. Pure information only (drop grammar; min tokens).
- Critical: DO NOT OVER-ENGINEER! This app is typically used by 2-5 people, internally only.

## Guardrails
- Use `trash` for deletes
- Use `mv` / `cp` to move and copy files
- Bugs: add regression test when it fits
- Keep files <~400 LOC; split/refactor as needed
- Simplicity first: handle only important cases; no enterprise over-engineering/fallbacks
- New functionality: small OR absolutely necessary
- NEVER delete files, folders or other data unless explicilty approved or part of a plan
- Before writing code, stricly follow the below research rules

## Research
- Prefer skills if available over research.
- Prefer researched knowledge over existing knowledge when skills are unavailable.
- Research: Exa to websearch early, and Ref to seek specific documention or web fetch.
- Best results: Quote exact errors; prefer 2025-2026+ sources.

## Error Handling
- Expected issues: explicit result types (not throw/try/catch).
- Unexpected issues: fail LOUD (throw/console.error + toast.error); NEVER add silent fallbacks.

## Project Memories
Use below list for durable project notes. Keep each item concise and remove stale notes when the project changes.

- Workspace: pnpm/Turbo monorepo. Main apps are `apps/web` (Next app, dev port 3009) and `apps/landing` (Next landing site, dev port 3002).
- Shell commands should use `rtk` to keep command output token-efficient.
- Explore code with Serena MCP first when available; use targeted shell reads/searches for files Serena cannot access.
- Shared editor code lives in `packages/core` and `packages/app`; `apps/web/next.config.ts` transpiles them as `@editor/core` and `@editor/app`.
- Web i18n: `apps/web` uses `next-intl`; supported locales are `en` and `zh`, selected from the `NEXT_LOCALE` cookie in `apps/web/i18n/request.ts`.
- Web copy lives in `apps/web/i18n/messages/{en,zh}.json`; user-facing text should use `useTranslations` or `getTranslations` and update both locale files.
- Landing i18n is separate: copy lives inline in `apps/landing/lib/i18n.ts`; update both `en` and `zh` entries there.
- DB-backed localized fields use `translations` jsonb and helpers in `apps/web/lib/localize-db.ts`; English columns are canonical and non-English locales fall back to English.
- Deployment uses OpenNext/Cloudflare. `apps/web` runs `scripts/patch-cloudflare-worker.mjs` after Cloudflare builds.
- AI/image/floorplan flows are standardized on Gemini via `@google/genai`; avoid reintroducing removed Flux/Bria-style providers unless explicitly requested.
