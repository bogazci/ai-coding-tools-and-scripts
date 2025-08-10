# Coding Rules for AI Coding Assistant – Compliance Checklist ✅
**Purpose:** Ensure all generated code is production-ready, secure, maintainable, and deployment-ready.

---

## 1. Core Code Quality
- [ ] **Human-readable:** Clear names, no cryptic shortcuts
- [ ] **Simple > Clever:** Avoid over-engineering
- [ ] **Maintainable:** Modular, consistent structure
- [ ] **Extendable:** Built for future features
- [ ] **Full working code:** No placeholders/TODOs
- [ ] **Error handling:** Try/catch & custom exceptions
- [ ] **Validation:** Inputs checked at all boundaries
- [ ] **Comments:** Explain *why*, not just *what*
- [ ] **Best practices:** PEP8 (Python), idiomatic code

---

## 2. Operational Standards
- [ ] **Config separation:** Secrets in `config.json`, never in code
- [ ] **Logging:** Structured (Python `logging`), no `print()`
- [ ] **Platform compatibility:** Works on Windows, macOS, Linux
- [ ] **Start/stop scripts:** Platform-compatible for all tiers
- [ ] **Docker-ready:** Dockerfiles & Compose (dev/prod)
- [ ] **Version control:** `.gitignore`, automation scripts, semantic versioning
- [ ] **Deployment guide:** `DEPLOY.md` with install/run/stop/debug steps

---

## 3. Security & Performance
- [ ] **Secure inputs:** Prevent SQL injection, XSS, CSRF
- [ ] **Rate limiting:** For APIs
- [ ] **Secrets handling:** Never exposed in code/logs
- [ ] **Performance:** Avoid N+1 queries, use caching, optimize loops
- [ ] **Resource cleanup:** Close DB/API connections

---

## 4. Monitoring & Observability
- [ ] **Health checks:** For services & dependencies
- [ ] **Metrics export:** Prometheus/OpenMetrics
- [ ] **Tracing:** OpenTelemetry for multi-service apps
- [ ] **Log correlation IDs:** Multi-request tracking
- [ ] **Audit logs:** User actions, system events, data changes

---

## 5. Resilience & Config Management
- [ ] **Retry/backoff strategies** for API calls
- [ ] **Circuit breaker** for unstable dependencies
- [ ] **Graceful shutdown hooks** (Docker/K8s safe)
- [ ] **Config versioning & env overrides** (dev/stage/prod)
- [ ] **Immutable infrastructure:** No in-place changes

---

## 6. AI/ML-Specific
- [ ] **Prompt governance:** Stored in version-controlled configs
- [ ] **LLM endpoint switching:** Runtime configurable
- [ ] **Token usage tracking & alerts** for cost control
- [ ] **Output safety checks:** Bias, toxicity, validation
- [ ] **Reproducibility:** Fixed model versions in config
- [ ] **Logging:** Model ID, prompt, parameters for each call

---

## 7. Process & Documentation
- [ ] **README.md:** Purpose, structure, setup, usage
- [ ] **CHANGELOG.md:** Semantic version updates
- [ ] **ADR:** Architecture Decision Records
- [ ] **API docs:** OpenAPI/Swagger
- [ ] **Deprecation policy:** Defined for APIs
- [ ] **Postmortem template:** For incident reviews

---

## 8. Testing
- [ ] **Unit tests:** Critical functions covered
- [ ] **Integration tests:** API endpoints
- [ ] **Mock external services** (e.g., OpenAI, Gemini)
- [ ] **Test config separate** from production
- [ ] **Coverage ≥ 80%** before merge

---

**✅ PASS:** Only deliver if **all boxes are checked**  
**🚫 FAIL:** If any box is unchecked — fix before delivery
