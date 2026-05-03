# Universal AI Coding Assistant – Compliance Rules

**Purpose:** A language-agnostic, framework-agnostic, project-agnostic ruleset for any AI coding assistant (Claude Code, OpenAI Codex, Gemini, Cursor, Copilot, etc.).
**Scope:** Applies to every project, every programming language, every runtime, every deployment target.
**Standard:** Production-ready, secure, observable, fully tested, fully documented — no exceptions.

---

## 0. Absolute Non-Negotiables (NEVER violate)

These are hard rules. If any of them is violated, the deliverable is rejected.

- **NEVER** ship stubs, mock-only implementations, fake responses, or hardcoded sample data in production paths
- **NEVER** ship pseudo-code, half-written functions, or "TODO: implement" markers
- **NEVER** ship placeholder strings (`foo`, `bar`, `lorem ipsum`, `xxx`, `changeme`) in shipped code
- **NEVER** ship static/dummy pages where dynamic functionality is expected
- **NEVER** ship code with `console.log`, `print()`, `dump()`, `var_dump()`, `dbg!()` debug statements left in
- **NEVER** ship commented-out code blocks
- **NEVER** ship code with disabled tests, skipped assertions, or `--no-verify` workarounds
- **NEVER** swallow exceptions silently (`catch {}`, `except: pass`, `_ = err`)
- **NEVER** hardcode secrets, credentials, API keys, tokens, or connection strings
- **NEVER** disable security features, type checks, or linters to make code "work"
- **NEVER** ignore failing tests, failing builds, or failing CI checks
- **NEVER** introduce breaking changes without explicit migration path and version bump

---

## 1. Senior-Level Quality Mandate

Every line of code must reflect the combined judgment of senior practitioners across all relevant disciplines. The AI must reason from each of these perspectives **simultaneously**:

| Perspective | Standard Applied |
|---|---|
| **Principal Architect** | System design, boundaries, scalability, evolvability, trade-off documentation |
| **Senior Developer** | Idiomatic code, language mastery, maintainability, readability, refactoring discipline |
| **Senior UX/UI Expert** | Accessibility (WCAG 2.2 AA), responsive design, intuitive flows, consistent design system, empty/loading/error states |
| **Senior Test Engineer** | Test strategy, coverage discipline, edge cases, mutation testing, deterministic tests |
| **Senior Cloud Engineer** | Infrastructure-as-code, scalability, cost awareness, multi-region readiness, failure modes |
| **Senior Security Engineer** | Threat modeling, OWASP Top 10, secure-by-default, least privilege, defense in depth |
| **Senior SRE / DevOps** | Observability, SLOs, incident response, deploy safety, rollback capability |
| **Senior Data Engineer** | Schema integrity, migration safety, data lineage, idempotency, backups |
| **Senior Product Engineer** | Feature completeness, user value, edge cases, real-world usage scenarios |

If any perspective would reject the code, the code is not ready.

---

## 2. Code Quality (Clean Code & Naming)

The discipline of writing readable code is called **Clean Code** (Robert C. Martin) and is enforced via **Naming Conventions** and a **Coding Style Guide** per language.

- **Human-readable identifiers**: descriptive names, no cryptic abbreviations (`getUserById` not `gUBI`, `customerEmail` not `cstEml`)
- **Naming convention adherence**: language-idiomatic (Python `snake_case`, Java/JS `camelCase`, types `PascalCase`, constants `UPPER_SNAKE_CASE`, etc.)
- **Self-documenting code**: code reads like prose; comments explain *why*, never *what*
- **Single Responsibility**: one function = one purpose; one class = one concern
- **Function size**: short, focused, low cyclomatic complexity (≤ 10), low nesting (≤ 3)
- **Principles applied**: SOLID, DRY, KISS, YAGNI, Law of Demeter, Composition over Inheritance
- **No magic numbers / strings**: extract to named constants
- **Consistent formatting**: enforced by formatter (Prettier, Black, gofmt, rustfmt, ktlint, etc.)
- **Linter-clean**: zero warnings; lint config checked into repo
- **Type safety**: strong typing wherever the language supports it (TypeScript strict, Python type hints + mypy/pyright, Java/Kotlin/Go/Rust native, etc.)
- **Immutability by default**: prefer `const`/`final`/`val`/immutable types
- **Pure functions** preferred; side effects isolated and explicit
- **No dead code**, no unused imports, no unreachable branches
- **Full implementations only**: every code path complete, every branch handled

---

## 3. Error Handling (Total Coverage)

Every possible failure mode must be caught, classified, logged, and surfaced cleanly.

- **Catch all errors**: every external boundary (I/O, network, parsing, user input, third-party calls) is wrapped
- **No silent failures**: every caught error is either handled meaningfully or re-raised with context
- **Custom exception hierarchy** for the domain
- **Error classification**: distinguish user errors, system errors, transient errors, fatal errors
- **Fail fast** on programming errors; fail safe on operational errors
- **Error messages — human-readable layer**: clear, actionable, non-technical message for end-users
- **Error messages — technical layer**: full technical detail (stack trace, request ID, parameters, environment) for operators/developers
- **Error response format**: structured (e.g., RFC 7807 Problem Details for HTTP), with `code`, `message`, `details`, `correlationId`, `timestamp`
- **No leaking internals to end users**: no stack traces in user-facing UI/responses
- **Resource cleanup guaranteed**: `try/finally`, `with`, `defer`, `using`, `Drop`, etc.
- **Retries** with exponential backoff + jitter for transient errors only
- **Circuit breakers** for unstable downstream dependencies
- **Timeouts** on every network/IO operation — no infinite waits
- **Graceful degradation**: partial functionality preferred over total failure
- **Validation at every boundary**: input validated at the edge, not deep inside

---

## 4. Logging & Observability (Always Full)

- **Structured logging** (JSON) — never plain `print`/`console.log` in production paths
- **Log levels** correctly used: TRACE, DEBUG, INFO, WARN, ERROR, FATAL
- **Every significant event logged**: request start/end, state transitions, external calls, errors, security events
- **Correlation/trace IDs** propagated through all layers and async boundaries
- **No sensitive data in logs**: PII, secrets, tokens, full payloads with credentials are redacted
- **Metrics exported**: RED (Rate, Errors, Duration) for services, USE (Utilization, Saturation, Errors) for resources — Prometheus/OpenMetrics format
- **Distributed tracing**: OpenTelemetry instrumentation across service boundaries
- **Health endpoints**: `/health/live`, `/health/ready` (Kubernetes-aware)
- **Audit logs**: who did what, when, from where, with what result — for every state-changing action
- **Log retention & rotation** configured
- **Dashboards & alerts** defined alongside the code (as code)

---

## 5. Testing (Full Coverage, No Compromise)

- **Coverage targets**: line ≥ 90%, branch ≥ 85%, critical paths 100%
- **Test pyramid**: many unit tests, fewer integration tests, few end-to-end tests
- **Unit tests**: every public function, every branch, every edge case
- **Integration tests**: every API endpoint, every DB interaction, every external integration (against contracts/mocks)
- **End-to-end tests**: every critical user journey
- **Contract tests** (Pact or equivalent) for service boundaries
- **Property-based tests** for algorithmic / data-transformation code
- **Mutation testing** for high-criticality modules
- **Performance tests** with defined SLOs (p50, p95, p99 latency; throughput; resource ceilings)
- **Load & stress tests** for production-bound services
- **Security tests**: SAST, DAST, dependency scanning, secret scanning
- **Accessibility tests** for UI: axe-core or equivalent, keyboard-only navigation, screen-reader checks
- **Visual regression tests** for UI
- **Deterministic tests**: no flakes, no time/order/network dependencies, seeded randomness
- **Tests isolated**: each test sets up and tears down its own state
- **Mocks for external services** (LLM APIs, payment, email, etc.) — never hit live in CI
- **Test data**: factories/builders, never copy-pasted fixtures
- **CI runs all tests** on every PR; no merge if anything is red

---

## 6. Security (Senior Security Engineer Lens)

- **Threat model documented** for every service
- **OWASP Top 10** mitigations verified (injection, broken auth, XSS, CSRF, SSRF, deserialization, etc.)
- **OWASP ASVS Level 2+** as baseline for web apps
- **Input validation & output encoding** at every boundary
- **Parameterized queries / prepared statements** — no string-built SQL ever
- **AuthN & AuthZ** explicit on every endpoint; default-deny
- **Least privilege** for every credential, service account, IAM role
- **Secrets management**: vault (HashiCorp Vault, AWS Secrets Manager, Doppler, etc.) — never in repo, never in env files committed
- **TLS everywhere**: TLS 1.2+ minimum, HSTS, certificate pinning where applicable
- **Cryptography**: only standard libraries, modern algorithms, no DIY crypto
- **Rate limiting & abuse prevention** on public endpoints
- **CSRF tokens**, **CSP headers**, **CORS** correctly scoped
- **Dependency scanning**: Snyk, Dependabot, Trivy, etc. — zero known criticals/highs at merge
- **SBOM** (Software Bill of Materials) generated per build (CycloneDX/SPDX)
- **Supply chain**: pinned versions, lockfiles committed, signed artifacts where possible
- **Secret scanning** on every commit (gitleaks, trufflehog)
- **Security headers** complete (HSTS, X-Frame-Options, X-Content-Type-Options, Referrer-Policy, Permissions-Policy)

---

## 7. Performance & Scalability

- **Algorithmic awareness**: complexity (Big-O) considered for hot paths
- **No N+1 queries**: eager-load, batch, or join
- **Caching strategy**: explicit (in-memory, Redis, CDN); cache invalidation documented
- **Connection pooling** for DB/HTTP
- **Async/non-blocking I/O** where the platform supports it
- **Backpressure** handled in queues and streams
- **Pagination** on every list endpoint — no unbounded responses
- **Resource budgets**: memory, CPU, file handles, sockets — limits set and tested
- **Profiling done** for performance-critical paths
- **Horizontal scalability**: stateless services, externalized session state
- **Database**: indexes on every query path, query plans reviewed
- **Frontend**: bundle size budgets, code-splitting, lazy loading, image optimization, Core Web Vitals targets

---

## 8. UX / UI (Senior UX/UI Expert Lens)

- **Accessibility (a11y)**: WCAG 2.2 AA minimum — semantic HTML, ARIA where needed, keyboard navigable, screen-reader tested, color contrast ≥ 4.5:1
- **Responsive design**: mobile-first, tested across breakpoints
- **Design system**: consistent tokens (color, spacing, typography), reusable components
- **All states handled**: empty, loading, error, success, partial, offline
- **Forms**: clear labels, inline validation, helpful error messages, autofill-friendly
- **Internationalization (i18n)**: no hardcoded user-facing strings, locale-aware dates/numbers/currencies, RTL support where relevant
- **Progressive enhancement**: works without JS where feasible
- **Performance UX**: skeleton screens, optimistic UI, perceived performance considered
- **Feedback**: every user action acknowledged within 100ms
- **Undo/confirmation** for destructive actions
- **Dark mode** supported where appropriate
- **No fake/static UIs**: every interactive element is wired to real backend behavior

---

## 9. Architecture (Principal Architect Lens)

- **Clear boundaries**: layered/hexagonal/clean architecture, bounded contexts (DDD)
- **Loose coupling, high cohesion**
- **API-first**: contracts defined before implementation (OpenAPI, gRPC proto, GraphQL schema)
- **API versioning** strategy (URI, header, or content negotiation) with deprecation policy
- **Backwards compatibility** preserved within a major version
- **Idempotency** on all mutating endpoints (idempotency keys for unsafe operations)
- **Event-driven where appropriate**: events documented, schemas versioned (Avro/Protobuf/JSON Schema)
- **CQRS / event sourcing** considered for complex domains
- **Stateless services** wherever possible
- **Architecture Decision Records (ADRs)** for every significant choice
- **C4 model diagrams** (context, container, component) checked into repo
- **Failure modes documented**: what breaks, how it's detected, how it recovers

---

## 10. Cloud, Infrastructure & Deployment (Senior Cloud Engineer Lens)

- **Infrastructure as Code**: Terraform, Pulumi, CDK, or equivalent — no click-ops
- **Containerized**: Dockerfile multi-stage, minimal base image (distroless/alpine), non-root user, healthcheck
- **Orchestration-ready**: Kubernetes manifests / Helm chart with proper probes, resource requests/limits, PodSecurityContext
- **12-Factor App** compliance
- **Configuration**: environment-based, hierarchical (default → env → secret), validated at startup
- **Secrets**: injected via secret manager, never baked into images
- **Cross-platform**: works on Linux, macOS, Windows (where relevant) for dev
- **Reproducible builds**: lockfiles committed, deterministic outputs, pinned tool versions
- **CI/CD pipeline**: lint → test → security scan → build → SBOM → sign → deploy → smoke test
- **Blue/green or canary deployments**; automated rollback on SLO breach
- **Graceful shutdown**: SIGTERM handled, in-flight requests drained
- **Zero-downtime deploys**: migrations backward-compatible, feature flags for risky changes
- **Multi-environment**: dev, staging, prod isolated; prod data never copied to lower envs without anonymization
- **Disaster recovery**: backups automated, restore tested, RPO/RTO documented
- **Cost awareness**: resource sizing justified, autoscaling configured

---

## 11. Data & Persistence

- **Schema migrations**: versioned, forward-only, reversible where possible (Flyway, Liquibase, Alembic, Prisma Migrate, etc.)
- **Migrations are backward-compatible** with the previous app version (expand → migrate → contract)
- **Transactions** used for multi-step writes; isolation level chosen explicitly
- **Concurrency**: optimistic/pessimistic locking chosen per case; race conditions analyzed
- **Referential integrity** enforced at DB level
- **Soft deletes** vs hard deletes decision documented
- **PII handling**: classified, encrypted at rest, access-logged, retention policy enforced
- **Backups**: automated, encrypted, restore drills run periodically
- **Time zones**: store in UTC, convert at presentation layer

---

## 12. Documentation (Always Complete)

- **README.md**: purpose, architecture overview, setup, run, test, deploy, troubleshoot
- **DEPLOY.md**: full deployment runbook (install, run, stop, debug, rollback)
- **CONTRIBUTING.md**: coding standards, branch strategy, PR process
- **CHANGELOG.md**: SemVer, Keep-a-Changelog format
- **ARCHITECTURE.md**: C4 diagrams, key flows, ADRs index
- **API docs**: OpenAPI/Swagger/AsyncAPI auto-generated and published
- **Inline docs**: public APIs documented (JSDoc/TSDoc/Pydoc/Javadoc/Rustdoc/etc.)
- **Runbooks**: for every alert, a documented response procedure
- **Postmortem template**: blameless, with timeline, root cause, action items
- **Onboarding guide**: a new engineer can run the system locally in under 30 minutes

---

## 13. Version Control & Process

- **Branch protection**: no direct pushes to main; PR + review required
- **Conventional Commits** (`feat:`, `fix:`, `chore:`, etc.) — enables automated changelog & versioning
- **Semantic Versioning** (MAJOR.MINOR.PATCH) strictly followed
- **Small PRs**: focused, reviewable in < 30 minutes
- **PR template**: what, why, how tested, screenshots, breaking-change flag
- **`.gitignore`** comprehensive (build artifacts, secrets, OS files, IDE files)
- **Pre-commit hooks**: format, lint, secret-scan, test
- **No force-push to shared branches**
- **Signed commits** where required by org policy
- **Code review**: at least one senior approval; address every comment

---

## 14. Compliance & Legal

- **License**: project license file present and correct
- **Third-party licenses**: tracked, compatible, attributed (NOTICE file)
- **GDPR / CCPA / regional privacy laws**: data subject rights implemented (export, deletion)
- **Cookie consent / tracking consent** implemented where applicable
- **Accessibility compliance** documented (Section 508, EN 301 549 where required)
- **Industry-specific**: HIPAA (healthcare), PCI-DSS (payments), SOC 2 controls (SaaS) — as applicable

---

## 15. AI / LLM-Specific (when project uses AI)

- **Prompts version-controlled** in config or dedicated prompt registry
- **Model & version pinned** for reproducibility
- **LLM endpoint configurable** at runtime (provider-swap-ready)
- **Token usage** tracked, logged, alert thresholds set
- **Cost dashboards** per feature/customer
- **Output validation**: schema-validated, safety-filtered, bias-checked
- **PII redaction** before sending to external LLM providers
- **Prompt injection defenses** (input sanitization, output verification, system-prompt isolation)
- **Fallback behavior** when LLM fails or returns invalid output
- **Caching** of deterministic prompts to reduce cost
- **Evaluation harness**: golden-set tests for prompt regressions
- **Per-call logging**: model ID, prompt, parameters, response, tokens, latency, cost

---

## 16. Operational Resilience

- **Retry with backoff + jitter** on all transient failures
- **Circuit breakers** on unstable dependencies
- **Bulkheads**: isolate failure domains (thread pools, connection pools)
- **Timeouts** on every external call
- **Idempotency keys** on all mutating client→server requests
- **Dead-letter queues** for unprocessable messages
- **Feature flags** for risky rollouts (LaunchDarkly, Unleash, OpenFeature)
- **Chaos testing** for critical services
- **SLOs defined**, error budgets tracked
- **On-call runbooks** for every alertable condition

---

## Definition of Done — Final Gate

A change is **done** only when **every** item below is true:

- [ ] All Section 0 non-negotiables respected
- [ ] All applicable senior perspectives (Section 1) satisfied
- [ ] Code clean, named idiomatically, formatter + linter pass with zero warnings
- [ ] All error paths handled, logged, and surfaced cleanly (human + technical)
- [ ] Structured logging, metrics, traces in place
- [ ] Tests written and passing; coverage targets met; no skipped/disabled tests
- [ ] Security review (SAST, deps, secrets) clean
- [ ] Performance acceptable against defined SLOs
- [ ] UX states (loading/empty/error/success) all implemented and accessible
- [ ] Documentation updated (README, CHANGELOG, API docs, ADRs as needed)
- [ ] Migration path & backward compatibility verified
- [ ] CI green; deploy & rollback rehearsed
- [ ] PR reviewed and approved by senior reviewer

**PASS:** Every box checked → ship.
**FAIL:** Any box unchecked → fix before delivery. No exceptions.
