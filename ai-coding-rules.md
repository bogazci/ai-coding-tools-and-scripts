# AI Coding Assistant — Universal Engineering Standard

A language- and project-agnostic quality bar for any code generated or modified by an AI coding assistant. Applies to scripts, libraries, services, frontends, infrastructure modules, and ML pipelines.

For a one-page version to paste into prompts, see [`ai-coding-rules-quickref.md`](./ai-coding-rules-quickref.md).

---

## 0. How to read this document

Rules come in two layers:

- **Hard Rules (§A)** — non-negotiable. Apply to every deliverable, in every language, at every size. Violations are bugs.
- **Standards (§1–§19)** — apply *when relevant to the deliverable*. A 200-line CLI helper does not need distributed tracing; a payment service does. Sections marked **[Baseline]** apply to anything beyond a one-off script. Sections marked **[Production-Service]** apply to anything that runs unattended, serves users, or holds data.

When a section does not apply, declare it explicitly in the PR/handoff:

```
N/A: §12 Accessibility — backend-only cron job
N/A: §11 Data — no persistence in scope
```

This is auditable. Silent omission is not.

If a user instruction conflicts with a rule, the user wins — but record the deviation (PR description, ADR, or commit message) so it is reviewable later.

---

## §A. Hard Rules

These are checked on every deliverable.

- [ ] **No stubs.** No `TODO`, `FIXME`, `pass`, `NotImplementedError`, `throw new Error("not implemented")`, no commented-out blocks marked "for later", no static UI where dynamic behavior is expected. If it is out of scope, *delete* it; do not stub it.
- [ ] **All errors caught at a meaningful boundary.** No unhandled exceptions, no swallowed promises, no ignored return codes, no empty `catch` blocks.
- [ ] **All test gates pass.** Format, lint, type check, unit, integration, and security scans are green before delivery. CI is the source of truth.
- [ ] **No fix without a failing test first.** Bug reports become regression tests *before* the fix lands.
- [ ] **No `--no-verify`, no skipped hooks, no disabled CI checks** to make a commit pass. Fix the underlying issue.
- [ ] **No secrets in code, logs, fixtures, error messages, or commit history.** Period.
- [ ] **Structured logging only** — no `print` / `console.log` / `fmt.Println` / `System.out` in shipped paths.
- [ ] **Inputs validated at every trust boundary** (HTTP, queue, file, env, CLI, FFI). Output encoded for the sink.
- [ ] **Deliverable passes the Multi-Perspective Quality Gate (§1)** with no open items in any applicable role.

If any Hard Rule is violated, the deliverable is **FAIL**, regardless of how complete the rest is.

---

## §1. Multi-Perspective Quality Gate

Before delivery, walk the work through every applicable role and answer their three questions. Open answers are open work.

| Role | Three questions to answer |
|---|---|
| **Principal Architect** | What is the blast radius of a failure here? What does the next year of change to this look like? Where is the coupling I will regret? |
| **Senior Developer** | Is this the most boring solution that works? Is the naming and structure self-explanatory? Is there dead code or duplication I missed? |
| **Senior Test Engineer** | Which behaviors are not covered by a test? Which tests are non-deterministic? Which failure mode is invisible to the suite? |
| **Senior UX/UI Expert** | What does this look like while loading, when empty, when failing, on the smallest supported viewport? Can I drive it with a keyboard? |
| **Senior Cloud Engineer** | What is the runtime cost? What happens at 10× load? Which dependency, if it goes away, breaks me? Are secrets injected, not baked? |
| **Senior Security Engineer** | Where is untrusted input, and where is it sanitized? Who can call this and how is that enforced? What gets logged that should not? |
| **Senior SRE / Operator** | When this pages me at 03:00, what runbook do I open? How do I roll it back? What signal tells me it is healthy? |

The gate is operational, not rhetorical: if a role has an open question, the work is not done.

---

## §2. Definition of Done by Task Type

The standard is the same; the surface area is not.

- **Bugfix** — failing test reproduces the bug → fix → test passes → no regression in adjacent paths → PR notes the root cause.
- **Refactor** — no behavior change → existing tests still pass without modification (modifying tests during a refactor is a smell) → public API unchanged or migration path documented.
- **Feature** — full §A Hard Rules + relevant Standards sections → docs updated → telemetry added if it is observable behavior → feature flag or kill-switch where rollback is non-trivial.
- **Spike / Prototype** — explicitly labeled as such → not merged to a release branch → followed by a real implementation or deletion.
- **Hotfix** — minimum viable change → regression test added in the same PR → backport to active release branches → postmortem follow-up tracked.

---

## §3. Code Quality & Clean Code

- [ ] **Naming conventions** consistent with the language's idiomatic style guide (PEP 8, Effective Go, Airbnb/Standard JS, .NET guidelines, Google style). Do not mix conventions inside one codebase.
- [ ] **Human-readable identifiers.** Full words; no cryptic abbreviations; single-letter names only in tight mathematical or loop scopes.
- [ ] **Simple beats clever.** Three similar lines beats a wrong abstraction. No premature generics, hooks, or plugin systems.
- [ ] **Small units.** One concern per function, file, and module. Narrow public surface.
- [ ] **SOLID, DRY, KISS, YAGNI** applied with judgment, not dogma.
- [ ] **Separation of concerns** between domain, I/O, transport, and presentation. Pure functions where possible.
- [ ] **Comments explain *why*, never *what*.** If the *why* is obvious, omit the comment. Dead code is deleted, not commented out.
- [ ] **Formatter and linter run automatically** with their config committed.

---

## §4. Errors & Failure Surfaces

(Validation lives in §6 Security; this section is the failure path.)

- [ ] **Domain-specific error types** with stable codes for programmatic handling — not raw `Error` / `Exception`.
- [ ] **Two-layer error messages:**
  - **Human layer:** plain language, actionable, no stack traces, localized if the product is localized.
  - **Technical layer:** error code, correlation ID, stack trace, context — logged and exposed to operators, never to end users.
- [ ] **Cause chains preserved** (`raise … from …`, `Error.cause`, `errors.Is/As`, `Throwable.getCause`). Never lose the original cause.
- [ ] **No empty catch.** If you intentionally ignore, log at `debug` and document why.
- [ ] **Fail loud in development, fail safe in production.** Crash on invariant violations during dev/test; degrade gracefully in prod.
- [ ] **Process-level safety nets** (uncaught-exception/unhandled-rejection handlers) log and exit cleanly — they do not paper over routine errors.

---

## §5. Logging & Observability

### [Baseline] (any non-trivial deliverable)

- [ ] **Structured logging** (JSON or key-value) via the language's standard logger.
- [ ] **Log levels used correctly** — `debug` for dev, `info` for lifecycle, `warn` for recoverable anomalies, `error` for failures, `fatal` for process-ending.
- [ ] **Every log line carries** UTC ISO-8601 timestamp, level, component, and a correlation/request ID where one exists.
- [ ] **Redaction enforced.** No secrets, tokens, full request bodies, or PII in logs.
- [ ] **Health endpoint** distinguishes "process alive" from "ready to serve traffic" (where the deliverable is a service).

### [Production-Service]

- [ ] **Metrics exported** in an open format (OpenMetrics/Prometheus, OTLP). RED for services, USE for resources.
- [ ] **Distributed tracing** (OpenTelemetry) across service boundaries; spans annotated with operation names and key attributes.
- [ ] **Audit log** for security- and compliance-relevant events (auth, permission change, data export, config change), separate from operational logs.
- [ ] **Performance budgets** declared as concrete numbers per critical path (e.g. `p95 < 200ms`, `bundle < 250KB`, `query < 50ms`) and enforced in CI or alerting.

---

## §6. Testing

- [ ] **No fix without a failing test first** (repeat from §A — this is where it happens in practice).
- [ ] **Unit tests** cover every branch of business logic. Pure-function logic is fully covered.
- [ ] **Integration tests** cover every external boundary: HTTP/RPC handlers, DB queries, queue consumers/producers, file I/O, third-party SDKs.
- [ ] **End-to-end tests** cover the critical user journeys.
- [ ] **Contract tests** at service boundaries when more than one service is in scope.
- [ ] **Property-based / fuzz tests** for parsers, serializers, and any code with a wide input space.
- [ ] **Negative tests** for every documented error mode.
- [ ] **Tests are deterministic** — no real network, no real clock, no flakiness. Time, randomness, IDs, and I/O are injected.
- [ ] **Test isolation** — no shared mutable state between tests. Fixtures live with the tests.
- [ ] **External services isolated** via fakes, contract-tested mocks, or ephemeral containers — never production or third-party prod from CI.
- [ ] **Coverage is by *behavior*, not lines.** Critical paths reach 100%; other code is covered to the level the risk requires. Line-coverage targets are a smoke check, not the goal — chasing a number produces tests that hit lines without proving behavior.
- [ ] **Tests run in CI on every push and PR.** Red CI blocks merge.

---

## §7. Security

- [ ] **OWASP Top 10 (web / API / mobile)** consciously addressed where applicable.
- [ ] **Input is untrusted by default.** Validate type, range, length, encoding, and semantics at every trust boundary. Reject early with a clear message.
- [ ] **Output encoded for the sink** — HTML, SQL, shell, LDAP, JSON, log. Parameterized queries always; never string-concatenated SQL.
- [ ] **Authentication** uses vetted libraries; no hand-rolled crypto. Passwords hashed with a modern KDF (argon2id, bcrypt, scrypt).
- [ ] **Authorization enforced server-side** on every protected operation; default-deny.
- [ ] **Secrets** in a secret manager or env vars injected at runtime. Never in source, logs, client bundles, fixtures, or commit history. `.env*` ignored. Rotation plan documented.
- [ ] **Transport** is TLS 1.2+; certificates validated; HSTS where applicable.
- [ ] **Dependencies scanned** for known CVEs (`npm audit`, `pip-audit`, `cargo audit`, `govulncheck`, Trivy, Dependabot/Renovate). Critical CVEs block release.
- [ ] **Supply chain** — lockfiles committed; reproducible installs; SBOM for releases when feasible.
- [ ] **Rate limiting and abuse controls** on public endpoints.
- [ ] **CSRF, CORS, CSP, cookie flags** (`HttpOnly`, `Secure`, `SameSite`) configured correctly for web apps.
- [ ] **Threat model** documented for security-critical features (auth, payments, PII handling) and revisited when trust boundaries change. Routine CRUD does not need its own threat model.

---

## §8. Data Classification & Sensitive Handling

- [ ] **Every data field is classified** as Public / Internal / Confidential / Restricted. Classification drives encryption, logging, retention, and cross-border rules.
- [ ] **PII identified, minimized, encrypted at rest, retained per policy, deletable on user request** (GDPR Art. 17, CCPA equivalents).
- [ ] **Money is never `float`.** Use a decimal type or integer minor units; currency travels with every amount.
- [ ] **Time always carries a time zone.** Store UTC; display in user TZ. Never compare naïve datetimes. ISO-8601 in transit and logs.
- [ ] **Identifiers exposed externally are opaque** (UUID/ULID) — never raw auto-increment DB IDs. Stable, non-guessable, non-enumerable.
- [ ] **Soft vs hard deletes** chosen consciously and documented per entity.

---

## §9. Performance & Resource Hygiene

- [ ] **No N+1 queries** — verified by query logs or assertions in integration tests.
- [ ] **Pagination, streaming, or chunking** for any unbounded result set or file.
- [ ] **Caching** considered (in-process, distributed, HTTP) with explicit TTL and invalidation strategy.
- [ ] **All resources released on every exit path** — connections, file handles, threads, goroutines, subscriptions, timers, listeners. `defer` / `using` / `try-with-resources` / `AbortController` used consistently.
- [ ] **Hot paths profiled** before optimizing. Optimizations justified by measurements.
- [ ] **Backpressure** handled in producer/consumer pipelines.

---

## §10. Concurrency & Reliability

- [ ] **Idempotency keys** on every non-GET external API and every retryable job.
- [ ] **Retries with exponential backoff and jitter** for transient failures; bounded retry budget.
- [ ] **Timeouts on every I/O call.** No infinite waits.
- [ ] **Circuit breakers / bulkheads** around unstable dependencies.
- [ ] **Graceful shutdown.** SIGTERM drains traffic, finishes in-flight work, closes resources, exits within the orchestrator's grace period.
- [ ] **Concurrency safety.** Shared state is immutable, single-owner, or protected by a documented synchronization primitive. Race detectors enabled in tests where the language supports them.
- [ ] **Delivery semantics stated** (at-least-once vs exactly-once) for every queue/event handler; consumers are idempotent.

---

## §11. Architecture, Contracts & APIs

- [ ] **Public APIs are versioned** (URL, header, or package version). Breaking changes require a new version and a documented deprecation window.
- [ ] **Contracts are explicit** — OpenAPI / AsyncAPI / gRPC proto / GraphQL SDL committed and used to generate clients/servers.
- [ ] **Schema evolution** is forward- and backward-compatible during the deprecation window.
- [ ] **Configuration vs code separated.** No environment-specific values hard-coded. Config validated on startup; the process refuses to start with invalid config.
- [ ] **12-Factor** compliance for services unless a section is consciously waived.
- [ ] **Architecture Decision Records (ADRs)** for non-obvious choices — one ADR per decision, dated, with context and consequences.

---

## §12. Data, Schema & Migrations

- [ ] **Migrations are version-controlled, reviewable, and idempotent.** A migration tool runs them; no ad-hoc DBA SQL.
- [ ] **Migrations are reversible** unless the rollback strategy is documented.
- [ ] **Zero-downtime schema changes follow Expand → Migrate → Contract:** add the new shape, dual-write/backfill, switch readers, then remove the old shape — never in one step.
- [ ] **Transactions wrap multi-statement writes** that must be atomic. Isolation level is a conscious choice.
- [ ] **Backups verified by restore drills**, not just by existence of backup files.
- [ ] **PII fields** classified per §8 with retention/deletion policy enforced in code.

---

## §13. Frontend, UX & Accessibility

- [ ] **WCAG 2.1 AA** as the floor — semantic HTML, keyboard navigation, focus management, color contrast, alt text, ARIA only where semantics fall short.
- [ ] **Loading, empty, error, and success states** designed and implemented for every async surface.
- [ ] **Form validation** is client-side for UX *and* server-side for trust. Messages are specific and actionable.
- [ ] **Responsive** across the target breakpoints; tested at the smallest supported viewport.
- [ ] **No layout shift** on load (CLS budget). Critical rendering path measured.
- [ ] **Internationalization (i18n)** ready — no hard-coded user-facing strings; locale, time zone, currency, plural rules, RTL handled by the i18n layer.
- [ ] **Analytics and consent** comply with the applicable privacy regime (GDPR, CCPA, etc.).

---

## §14. Build, Dependencies & Reproducibility

- [ ] **Lockfiles committed** (`package-lock.json` / `pnpm-lock.yaml` / `poetry.lock` / `Cargo.lock` / `go.sum` / etc.).
- [ ] **Pinned toolchain version** (`.nvmrc`, `.python-version`, `rust-toolchain.toml`, Go directive in `go.mod`, `.tool-versions`).
- [ ] **Reproducible builds** — same input produces the same artifact bit-for-bit where the toolchain supports it.
- [ ] **Clean-checkout buildable** via documented commands; no untracked global installs required.
- [ ] **Dependency adoption is deliberate.** Audit transitive size, license, and maintenance health before pulling in.
- [ ] **License compliance** — every dependency's license recorded; copyleft licenses reviewed before adoption; project's own `LICENSE` present.
- [ ] **Update cadence** — automated dependency updates (Renovate/Dependabot) on a defined schedule. Security patches merged within 7 days.

---

## §15. CI / CD, Review & Release

- [ ] **CI on every push and PR** — format, lint, type check, unit tests, integration tests, security scan, build. Branch protection requires green CI and review before merge to the default branch.
- [ ] **PRs are small and single-purpose.** Aim for ≤ 400 lines of diff. One change of intent per PR. Mixed concerns split into separate PRs.
- [ ] **Review is mandatory and substantive.** Approvals on `LGTM` without reading the diff are a process failure.
- [ ] **Deployments are automated and reversible.** Manual production steps documented and minimized.
- [ ] **Risky changes ship behind a feature flag or kill-switch** with the rollback path tested before enabling for users.
- [ ] **Progressive delivery** (canary, blue/green) for changes with broad blast radius.
- [ ] **Semantic versioning** for libraries; conventional commits or equivalent for changelog generation.
- [ ] **CHANGELOG.md** kept current or generated from commit history.

---

## §16. Containers & Infrastructure

- [ ] **Dockerfile** uses a pinned base image, runs as a non-root user, has a `HEALTHCHECK`, and produces a small final image (multi-stage build).
- [ ] **Compose / Helm / Terraform / Pulumi / CloudFormation** present for every environment they target.
- [ ] **Infrastructure as Code is the source of truth** — no click-ops in production.
- [ ] **Resource requests/limits** set on every container.
- [ ] **Secrets injected at runtime** from a secret manager; never baked into images.
- [ ] **Region, AZ, and failure-domain assumptions** are documented.

---

## §17. AI / ML / LLM-Specific

### [Baseline] (any code that calls a model)

- [ ] **Model and provider IDs are configurable** at runtime — never hard-coded.
- [ ] **Model versions pinned** for reproducibility; upgrades are deliberate.
- [ ] **Token, request, and cost usage logged** per call: model ID, prompt template ID, parameter set, latency, input/output tokens, cost.
- [ ] **Cost ceilings** in place — runaway loops have hard caps.
- [ ] **Customer/PII data is not sent to third-party models** unless contractually permitted and logged.

### [AI-Product] (the model output is the product)

- [ ] **Prompts and templates version-controlled** alongside code; not edited live in a console.
- [ ] **Inputs validated** (length, content policy) and **outputs validated** (schema, safety filters, hallucination guards) before use.
- [ ] **Evaluation harness** exists for prompt/model changes. Regressions block release. No "looks good to me" deploys.
- [ ] **Determinism aids** (temperature, seeds where supported) used in tests; non-determinism is contained behind interfaces that can be faked.

---

## §18. Documentation

- [ ] **README.md** — purpose, prerequisites, install, run, test, build, common tasks, links to deeper docs.
- [ ] **CONTRIBUTING.md** — branching, commit style, review process, local setup.
- [ ] **DEPLOY.md / RUNBOOK.md** — how to deploy, roll back, debug in production, common alerts and their responses.
- [ ] **API docs** generated from the contract (OpenAPI/proto/SDL) and published.
- [ ] **ADRs** for non-obvious architecture decisions.
- [ ] **CHANGELOG.md** kept current.
- [ ] **Inline docs** on every exported symbol of every public package/module.

---

## §19. Operations, DR & Lifecycle

- [ ] **Incident response** — on-call rotation, alerting routes, severity definitions, postmortem template documented.
- [ ] **Postmortems are blameless and produce action items** that are tracked to completion.
- [ ] **RTO and RPO** stated for every stateful system; backups and failover are exercised, not assumed.
- [ ] **Compliance scope** (e.g. SOC 2, ISO 27001, HIPAA, PCI-DSS, GDPR) declared per project; controls mapped where applicable.
- [ ] **Delete plan.** Every feature, table, endpoint, flag, and dependency has a documented removal path. Codebases only grow when removal is unowned.
