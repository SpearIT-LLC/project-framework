# Anthropic Plugin Standards Research

**Date:** 2026-02-09
**Purpose:** Document official Anthropic plugin structure and standards for FEAT-118 implementation
**Sources:**
- https://github.com/anthropics/claude-plugins-official
- https://code.claude.com/docs/en/discover-plugins

---

## 1. Required Directory Structure

```
plugin-name/
├── .claude-plugin/
│   └── plugin.json      # Plugin metadata (REQUIRED)
├── .mcp.json            # MCP server configuration (optional)
├── commands/            # Slash commands (optional)
├── agents/              # Agent definitions (optional)
├── skills/              # Skill definitions (optional)
└── README.md            # Documentation (recommended)
```

**For FEAT-118 (spearit-framework-light):**
```
spearit-framework-light/
├── .claude-plugin/
│   └── plugin.json      # ✅ REQUIRED
├── commands/            # ✅ REQUIRED (4 commands)
│   ├── fw-move.md
│   ├── fw-next-id.md
│   ├── fw-session-history.md
│   └── fw-help.md
├── skills/              # ✅ REQUIRED (3 skills)
│   ├── kanban-workflow.md
│   ├── work-items.md
│   └── moving-items.md
└── README.md            # ✅ REQUIRED
```

---

## 2. Plugin Metadata (plugin.json)

**Location:** `.claude-plugin/plugin.json`

**Required Fields:**
- `name` - Unique identifier (internal name, no spaces)
- `version` - Semantic versioning (e.g., "1.0.0")
- `description` - Brief description of plugin functionality
- `author` - Plugin creator information

**Additional Fields (recommended):**
- `homepage` - Link to plugin documentation/repository
- `keywords` - Array of searchable keywords
- `displayName` - Human-readable name (can include spaces)

**For FEAT-118:**
```json
{
  "name": "spearit-framework-light",
  "displayName": "SpearIT Project Framework - Lightweight Edition",
  "version": "1.0.0",
  "description": "File-based Kanban workflow for solo developers and small teams",
  "author": "Gary Elliott / SpearIT Solutions",
  "homepage": "https://github.com/spearit-solutions/project-framework",
  "keywords": ["kanban", "project-management", "workflow", "solo-developer", "small-team", "file-based"]
}
```

---

## 3. Command Naming Conventions

**Pattern:** `/plugin-name:command-name`

**Examples:**
- `/commit-commands:commit` (from commit-commands plugin)
- `/pr-review-toolkit:review` (from pr-review-toolkit plugin)

**For FEAT-118:**
- `/spearit-framework-light:move` (fw-move.md)
- `/spearit-framework-light:next-id` (fw-next-id.md)
- `/spearit-framework-light:session-history` (fw-session-history.md)
- `/spearit-framework-light:help` (fw-help.md)

**Important Notes:**
1. Files keep descriptive prefixes (fw-move.md for clarity in filesystem)
2. Commands drop prefix (namespace provides context: `:move` not `:fw-move`)
3. Namespace separates plugin commands from local commands
4. Follows Anthropic's pattern (namespace + short command name)

---

## 4. Skills Documentation Format

**Location:** `skills/` directory

**Best Practices:**
- Keep concise (total under 300 lines for context limits)
- Focus on concepts, not implementation details
- Clear, simple explanations (not academic)
- Use markdown format
- Provide examples where helpful

**For FEAT-118:**
- `kanban-workflow.md` (~100 lines) - File-based Kanban concept
- `work-items.md` (~75 lines) - Creating/managing work items
- `moving-items.md` (~75 lines) - Workflow transitions

---

## 5. Installation Process

**Three Installation Scopes:**

1. **User scope** (default): Install for yourself across all projects
   ```
   /plugin install plugin-name@marketplace-name
   ```

2. **Project scope**: Install for all collaborators (adds to `.claude/settings.json`)
   ```
   /plugin install plugin-name@marketplace-name --scope project
   ```

3. **Local scope**: Install for yourself in this repository only (not shared)
   ```
   /plugin install plugin-name@marketplace-name --scope local
   ```

**Interactive UI:** Run `/plugin` → **Discover** tab → select plugin → choose scope

---

## 6. Distribution Methods

**Primary Channel: Official Anthropic Marketplace**
- Marketplace ID: `claude-plugins-official`
- Auto-available when Claude Code starts
- Submission: https://clau.de/plugin-directory-submission
- Auto-update support
- Best visibility and trust

**Secondary Channels: Community Marketplaces**
- Example: `anthropics/claude-code` (demo marketplace)
- GitLab, Bitbucket, self-hosted Git
- Local directories
- Remote URLs (marketplace.json)

**For FEAT-118 MVP:** Submit to official marketplace only

---

## 7. Submission Requirements

**Quality Standards:**
- Clean, well-written code
- Comprehensive documentation
- Usage examples for all commands
- Professional README

**Security Standards:**
- No malicious code
- Safe dependencies
- Transparent behavior
- Clear homepage with plugin info

**Submission Process:**
1. Create plugin package (complete structure)
2. Test thoroughly (local installation)
3. Submit via form: https://clau.de/plugin-directory-submission
4. Wait for Anthropic review/approval

**Important Warning:**
> ⚠️ Users must trust plugins before installing. Anthropic cannot verify that plugins work as intended or won't change. Each plugin's homepage provides transparency information.

---

## 8. Marketplace Structure (for future reference)

**Marketplace definition:** `.claude-plugin/marketplace.json`

**Location options:**
- GitHub repository (owner/repo format)
- Git URL (GitLab, Bitbucket, self-hosted)
- Local directory
- Remote URL

**For FEAT-118:** Plugin will be part of official marketplace (no custom marketplace needed for MVP)

---

## 9. Plugin Categories (Official Marketplace)

**Categories observed:**
1. **Code intelligence** - LSP plugins for language support
2. **External integrations** - Pre-configured MCP servers (GitHub, Jira, Slack, etc.)
3. **Development workflows** - Git workflows, PR reviews, SDK development
4. **Output styles** - Response customization

**FEAT-118 Category:** Development workflows (project management/Kanban workflow)

---

## 10. Auto-Updates

**Default behavior:**
- Official Anthropic marketplaces: Auto-update enabled
- Third-party/local marketplaces: Auto-update disabled

**When auto-update enabled:**
- Refreshes marketplace data at startup
- Updates installed plugins to latest versions
- Notification shown if plugins updated
- Suggests restart after updates

**User control:**
- Can disable per-marketplace in `/plugin` → **Marketplaces** tab
- Environment variable `DISABLE_AUTOUPDATER=true` disables all updates
- `FORCE_AUTOUPDATE_PLUGINS=true` + `DISABLE_AUTOUPDATER=true` = only plugin updates

---

## 11. Build and Distribution Best Practices

**Package structure:**
- ZIP archive containing plugin folder
- Folder name matches plugin name (`spearit-framework-light/`)
- All required files included
- No external dependencies in commands (self-contained)

**For FEAT-118:**
- Build script: `tools/Build-Plugin.ps1`
- Output: `distrib/plugin-light/spearit-framework-light-v1.0.0.zip`
- Contents: Complete `spearit-framework-light/` directory

---

## 12. Key Differences: Local Commands vs Plugin Commands

| Aspect | Local Commands (.claude/commands/) | Plugin Commands (plugins/*/commands/) |
|--------|-----------------------------------|-------------------------------------|
| **Invocation** | `/fw-move` (prefix required) | `/spearit-framework-light:move` (namespace required) |
| **Scope** | Single project only | User/project/local scope options |
| **Distribution** | Manual copy to each project | Marketplace installation |
| **Updates** | Manual file updates | Auto-update support |
| **Conflicts** | Can conflict with other projects | Namespace prevents conflicts |
| **File naming** | fw-move.md (prefix for clarity) | fw-move.md (same, internal) |

**Key Insight:** Different namespaces allow dogfooding both local commands (for framework development) and plugin commands (for testing distribution) simultaneously without conflicts.

---

## 13. Example Reference Plugins

**Studied for patterns:**
- `commit-commands` - Git workflow commands (good command structure example)
- `pr-review-toolkit` - Specialized agents (workflow patterns)
- `plugin-dev` - Plugin development toolkit (meta-example)

**Common patterns observed:**
1. Clear command names (action-oriented)
2. Comprehensive README with examples
3. Focused scope (do one thing well)
4. Professional metadata
5. Security considerations documented

---

## 14. Testing Recommendations

**Before submission:**
1. ✅ Install plugin locally (test installation process)
2. ✅ Test each command from plugin location (not local)
3. ✅ Verify skills load in Claude context
4. ✅ Check for broken references/links
5. ✅ Test in target environment (framework project)
6. ✅ Test in non-target environment (graceful degradation)
7. ✅ Verify no conflicts with local commands
8. ✅ Test ZIP package structure

**Debug tools:**
- `/plugin` → **Errors** tab for loading issues
- `rm -rf ~/.claude/plugins/cache` to clear cache
- Check `$PATH` for binary dependencies (if any)

---

## 15. Anthropic's Development Process (Key Takeaways)

**What we learned:**
1. **Structure first** - Follow exact directory pattern, no variations
2. **Namespace everything** - Commands must be namespaced with plugin name
3. **Self-contained** - Plugins copied to cache, no external path dependencies
4. **Professional quality** - Official marketplace has high bar (not just functional)
5. **Security matters** - Transparency required, user must trust before install
6. **Simple scope** - Start focused, can expand based on user feedback
7. **README critical** - Primary user documentation, must be comprehensive
8. **Examples required** - Every command needs usage examples

**For FEAT-118 implementation:**
- ✅ Match structure exactly (no deviations)
- ✅ Use official namespace pattern
- ✅ Keep commands self-contained
- ✅ Write professional README
- ✅ Document security/transparency
- ✅ Start with 4 core commands (focused scope)
- ✅ Provide comprehensive examples

---

## 16. Critical Success Factors

**Must-haves for approval:**
1. ✅ Exact directory structure match
2. ✅ Valid plugin.json with all required fields
3. ✅ Commands work from plugin location (not just local)
4. ✅ Professional README with examples
5. ✅ No broken references or dependencies
6. ✅ Clear security/transparency documentation
7. ✅ Proper namespace usage
8. ✅ ZIP package structure correct

**Nice-to-haves for success:**
1. Clear installation instructions
2. Quick start guide (5-minute workflow)
3. Links to comprehensive documentation
4. Keywords optimized for discovery
5. Professional presentation
6. Graceful error handling

---

## Conclusion

**Anthropic's plugin ecosystem is mature and well-structured.** The standards are clear, the patterns are consistent, and the quality bar is high. Our implementation must:

1. **Follow the pattern exactly** - No creative interpretations
2. **Be self-contained** - No external dependencies in commands
3. **Use proper namespacing** - `/spearit-framework-light:command`
4. **Provide professional documentation** - README is critical
5. **Test thoroughly** - Installation and usage must work flawlessly
6. **Be transparent** - Clear about what the plugin does and requires

**Next Steps for FEAT-118:**
- ✅ Milestone 1 complete (research documented)
- → Milestone 2: Create plugin package structure (match Anthropic pattern exactly)

---

## 17. Licensing and Repository Visibility (Added 2026-02-09)

**Repository Visibility:**
- **Requirement:** Not explicitly stated, but strongly implied
- **Recommendation:** Public repositories for transparency/trust
- **Rationale:** Marketplace emphasizes "users must trust plugins before installing"
- **Each plugin's homepage provides transparency information**

**Plugin Licensing:**
- **Anthropic requirement:** No explicit license mandate found
- **Claude Code itself:** Proprietary (Anthropic Commercial Terms)
- **Official Anthropic plugins:** Appear to be open source on GitHub
- **Community practice:** Most use permissive licenses (MIT, Apache 2.0)

**Recommended License Options:**
1. **MIT License** (most common, simple, permissive) ✅
2. **Apache 2.0** (also popular, includes patent protection)
3. **BSD** (similar to MIT, less common)

**Why permissive licenses align with ecosystem:**
- Allows users to inspect code before trusting
- Enables community contributions and forks
- Aligns with transparency/trust model
- Standard practice in plugin marketplaces

**Decision for FEAT-118:**
- Deferred to Milestone 8 (before submission)
- Recommendation: MIT License
- Plugin license can differ from framework license
- Repository should be public before submission

---

## Additional Resources

**Best Practices:** See `claude-plugin-best-practices.md` for lessons learned during plugin development, including:
- Command performance optimization
- Command isolation strategies
- Schema validation approaches
- Debug workflows
- Testing strategies

---


**Research completed:** 2026-02-09
**Confidence level:** HIGH - Official sources, clear standards, consistent patterns
**Ready to implement:** YES - All required information documented
**Licensing:** Deferred decision (MIT recommended)
**Performance:** Critical optimization patterns documented
