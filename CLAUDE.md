# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

This repo is a **personal collection of reference docs and setup scripts** for AI-assisted development — not an application. It is intended to be consumed by AI coding assistants (Claude Code, Codex CLI, Gemini CLI, etc.) and by humans setting up dev machines. There is no build, test, or lint pipeline.

## Contents

- `dev-setup.sh` — large interactive Bash menu (~2400 lines) that installs and configures dev tools on Ubuntu/macOS. Runs as `bash dev-setup.sh`. The main `while true; do ... case "$choice" in ...` loop at the bottom dispatches to top-level menus: Dev Tools, GitHub project bootstrap, DB/env mgmt, AI tooling install (Claude Code CLI, OpenAI Codex CLI), VS Code extensions, status check, help. All function names are `install_*`, `show_*_menu`, `setup_*`, `start_*`/`stop_*` — search by prefix to find the relevant block. UI strings are German; identifiers and code are English.
- `ai-coding-rules.md` — universal, language-agnostic engineering standard the user wants applied to generated code. Structured as **Hard Rules (§A)** that always apply + **Standards (§1–§19)** that apply when relevant, with sections marked `[Baseline]` vs `[Production-Service]` vs `[AI-Product]` so the bar scales with deliverable size. When a section does not apply, declare it explicitly (`N/A: §X — reason`) rather than silently skipping.
- `ai-coding-rules-quickref.md` — one-page paste-into-prompt version of the above. Use this when handing rules to another assistant or pasting into a system prompt; use the full file as the reference.
- `ui-design.md` — design system spec for "GTM Machine v3" (React + TypeScript + Tailwind v4). Reference when generating UI in *other* projects that should match this look.
- `azure-ai-foundry-endpunkte.md` — Azure AI Foundry endpoint URLs and example client code.
- `Setting up MySQL on Ubuntu` — short MySQL install/admin cheat sheet (no extension).

## Working in this repo

- Most files are standalone Markdown references — edit in place; there is nothing to compile or run to verify.
- When editing `dev-setup.sh`, preserve its conventions: `tput`-based color vars (`FG_RED`, `FG_GREEN`, …, `RESET`), German user-facing prompts, emoji status markers (✅ ❌ 🔍 📦), and the `function_name() { ... }` style. New features should plug into one of the existing menus rather than adding new top-level prompts.
- `dev-setup.sh` contains placeholder API-key variables at the top (`OPENAI_API_KEY_PRESET`, `ANTHROPIC_API_KEY_PRESET`). Leave them empty in commits — they are local-edit slots.
- `azure-ai-foundry-endpunkte.md` contains what look like real-looking API keys next to endpoint URLs. Treat as sensitive: do not echo them into new files, logs, or PR descriptions, and warn the user before committing changes that would propagate them.
