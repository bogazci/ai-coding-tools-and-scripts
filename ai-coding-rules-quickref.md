# AI Coding Rules — Quickref

One-page paste-into-prompt version. Full standard: [`ai-coding-rules.md`](./ai-coding-rules.md).

## Hard Rules — every deliverable, every language

1. **No stubs.** No `TODO`, `FIXME`, `pass`, `NotImplementedError`, no static UI where dynamic is expected. Out of scope = delete, not stub.
2. **All errors caught at a meaningful boundary.** No empty catch, no swallowed promises, no ignored return codes.
3. **All test gates green** — format, lint, type, unit, integration, security scan — before delivery.
4. **No fix without a failing test first.** Bug → regression test → fix.
5. **No `--no-verify`, no skipped hooks, no disabled CI checks** to make a commit pass. Fix the cause.
6. **No secrets** in code, logs, fixtures, error messages, or commit history.
7. **Structured logging only** — no `print` / `console.log` in shipped paths.
8. **Validate input at every trust boundary; encode output for the sink.**

## Quality Gate — answer all that apply before shipping

- **Architect** — blast radius? next year of change? coupling I will regret?
- **Developer** — most boring solution? names self-explanatory? dead code/duplication?
- **Test Engineer** — uncovered behaviors? non-deterministic tests? invisible failure modes?
- **UX/UI** — loading/empty/error/success states? smallest viewport? keyboard?
- **Cloud** — runtime cost? 10× load? secrets injected not baked?
- **Security** — untrusted input boundaries? authorization enforced? logging exposure?
- **SRE** — runbook at 03:00? rollback path? health signal?

## Mechanics — the things that bite

- **Money** never `float` — decimal or integer minor units; currency travels with amount.
- **Time** always with TZ; store UTC, display local; ISO-8601 in transit.
- **External IDs** opaque (UUID/ULID), never raw auto-increment.
- **PII** classified, encrypted at rest, deletable on user request.
- **Migrations** Expand → Migrate → Contract. Reversible or rollback documented.
- **I/O** every call has a timeout, a retry policy with jitter, and a circuit breaker for unstable deps.
- **Idempotency keys** on every non-GET external API and every retryable job.
- **Resources** released on every exit path (`defer` / `using` / `try-with-resources` / `AbortController`).
- **APIs** versioned; contracts (OpenAPI/proto/SDL) committed; schema changes back- and forward-compatible.
- **Feature flags / kill-switches** for risky changes; rollback path tested before enabling.

## Definition of Done by task type

- **Bugfix** — failing test → fix → no adjacent regressions → root cause noted.
- **Refactor** — no behavior change → existing tests pass unmodified → API stable or migration documented.
- **Feature** — Hard Rules + relevant standards + docs + telemetry + flag/kill-switch.
- **Hotfix** — minimum change → regression test in same PR → backport → postmortem follow-up.
- **Spike** — labeled, not merged to release, replaced by real impl or deleted.

## PR hygiene

- ≤ 400 lines diff, single purpose, single intent.
- Review is substantive; `LGTM` without reading the diff is a process failure.
- N/A sections declared explicitly: `N/A: §13 Accessibility — backend cron job`.

## Shipping checklist

`[ ] hard rules` `[ ] quality gate` `[ ] tests deterministic & green` `[ ] logs structured & redacted` `[ ] secrets in vault` `[ ] errors typed & two-layer` `[ ] timeouts/retries/idempotency` `[ ] docs & changelog` `[ ] rollback path`
