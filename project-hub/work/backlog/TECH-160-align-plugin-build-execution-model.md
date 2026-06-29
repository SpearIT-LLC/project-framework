# Tech Debt: Align Build-Plugin.ps1 Execution Model with Build-FrameworkArchive.ps1

**ID:** TECH-160
**Type:** Tech Debt
**Priority:** Medium
**Version Impact:** PATCH
**Created:** 2026-06-29
**Theme:** Distribution Hygiene

---

## Summary

`tools/Build-Plugin.ps1` still produces its archive with `Compress-Archive` (line ~323), the same call TECH-159 replaced in `Build-FrameworkArchive.ps1` because it emits **OS-native backslash path separators** that break extraction on macOS/Linux. The plugin archives should follow the **same execution model** as the framework build — fresh temp dir, mirror-from-source semantics, and forward-slash zip entries — even though *what* they bundle differs.

---

## Problem Statement

**What is the current state?**

- `Build-Plugin.ps1:~323` uses `Compress-Archive -Path $tempContents -DestinationPath $zipPath -Force`.
- On the build host this records backslash separators in zip entry names (verified for the framework archive under TECH-159; same API, same behavior expected here).
- Result: plugin distribution zips likely extract incorrectly on non-Windows systems (files land flat with literal `\` in the name).

**Why is this a problem?**

- Cross-platform consumers of the plugin archives get a broken directory structure.
- Two divergent zip implementations in the repo (`Build-FrameworkArchive.ps1` now correct, `Build-Plugin.ps1` not) — the exact "rogue method" divergence the framework side just eliminated.

**What is the desired state?**

- `Build-Plugin.ps1` zips with forward-slash entry names (cross-platform-correct), matching `Build-FrameworkArchive.ps1`.
- Both build scripts share the **same zip behavior**. Consider extracting the forward-slash `System.IO.Compression` logic into a shared helper both call, so there is genuinely one zip method repo-wide (optional — behavior parity is the requirement; shared code is the nice-to-have).
- Plugin build also follows fresh-temp / mirror-from-source semantics so additions/edits/removals propagate cleanly (verify current behavior; fix if it reuses a dirty temp).

---

## Proposed Solution

1. Replace the `Compress-Archive` call in `Build-Plugin.ps1` with the forward-slash `System.IO.Compression.ZipFile` pattern used in `Build-FrameworkArchive.ps1` (Step 7).
2. **Optional/preferred:** factor that zip routine into a shared script/function (e.g. `tools/lib/New-ForwardSlashZip.ps1`) imported by both build scripts, so the method exists in exactly one place.
3. Verify `Build-Plugin.ps1` uses a fresh temp dir per run (mirror semantics); fix if not.
4. Rebuild each plugin, extract on a forward-slash-aware tool, confirm correct directory structure.

**Files Affected:**
- `tools/Build-Plugin.ps1` — zip method (+ temp-dir check)
- (optional) `tools/lib/New-ForwardSlashZip.ps1` — new shared helper
- (optional) `tools/Build-FrameworkArchive.ps1` — switch to shared helper if extracted

---

## Acceptance Criteria

- [ ] `Build-Plugin.ps1` no longer uses `Compress-Archive`; plugin zips use forward-slash entry names
- [ ] A built plugin zip extracts with correct subdirectories on a forward-slash-aware unzip
- [ ] Plugin build verified to use fresh-temp / mirror-from-source semantics (or fixed)
- [ ] (If shared helper extracted) both build scripts call the one zip routine
- [ ] CHANGELOG.md (plugin) updated

---

## Notes

- Split from TECH-159 by design (user, 2026-06-29): "The plugin builds are a separate matter, although they should behave the same from an execution perspective, even if the details of what it's doing is different." TECH-159 was kept framework-only.
- The backslash-path defect and its forward-slash fix are documented in TECH-159 and `project-hub/research/starter-duplication-audit.md`.

---

## Related

- **TECH-159** — eliminated starter duplication + fixed the backslash-path zip bug in the *framework* build; established the forward-slash zip pattern this item ports to plugins.
- **Build-Plugin.ps1** — current plugin build (full + light plugins per `framework.yaml` products).
