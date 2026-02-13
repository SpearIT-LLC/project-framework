# Repository Publication Checklist

**Purpose:** Reusable checklist for making repositories public and preparing for external visibility.

**Last Used:** 2026-02-13 (Plugin Light v1.0.0 submission)

---

## Pre-Publication Review

### 1. Documentation Updates

- [ ] **README.md** - Update to reflect current state
  - Clear description of what the project is
  - Installation/quick start instructions
  - Product positioning (if multiple products)
  - Version strategy explained
  - Link to detailed documentation

- [ ] **CONTRIBUTING.md** - Create or update
  - Project status and version
  - How to report bugs/suggest features
  - Code contribution policy (accepting vs not accepting)
  - Contact information

- [ ] **LICENSE** - Verify license file exists and is correct
  - Standard license text (MIT, Apache, etc.)
  - Copyright holder and year correct

---

### 2. Repository Hygiene

- [ ] **Branding Consistency**
  - Organization name consistent across all files
  - GitHub org URL matches everywhere
  - Email domains correct
  - Contact information up to date

- [ ] **.gitignore Review**
  - Sensitive files excluded (.env, credentials, etc.)
  - Build artifacts excluded
  - IDE/editor files excluded
  - Cloud provider configs excluded

- [ ] **Commit History Review**
  - No sensitive data in commit messages
  - No API keys or secrets in any commit
  - Professional commit messages
  - No embarrassing temporary commits on main branch

---

### 3. Security & Privacy

- [ ] **Sensitive Data Scan**
  - No `.env` files committed
  - No API keys or tokens in code
  - No passwords or credentials
  - No private URLs or internal endpoints
  - No personal data (emails, names, etc.) unless intentional

- [ ] **Repository Secrets**
  - GitHub Actions secrets configured (if using CI/CD)
  - Dependabot alerts reviewed
  - Security policy exists (if applicable)

---

### 4. Content Review

- [ ] **Documentation Accuracy**
  - Version numbers correct everywhere
  - Links work (no 404s)
  - Installation instructions tested
  - Contact emails valid
  - External references accurate

- [ ] **Work-in-Progress Content**
  - No TODO/FIXME indicating incomplete features (future features OK)
  - No draft documents in main branch
  - No placeholder content ("coming soon" is fine if intentional)

- [ ] **Internal Notes**
  - Decide whether to expose project management files (project-hub/, etc.)
  - If exposing: ensure professional presentation
  - If hiding: add to .gitignore before going public

---

### 5. Release Tagging

- [ ] **Version Tags**
  - Create annotated tag for release
  - Tag message includes version, features, notes
  - Tag naming convention established
  - Tags pushed to remote

**Tag format examples:**
- Plugin releases: `plugin-light-v1.0.0`, `plugin-v2.0.0`
- Framework releases: `v5.1.0`, `v6.0.0`
- Hotfixes: `v5.1.1-hotfix`

---

### 6. GitHub Settings

Before making repository public, configure:

- [ ] **Repository Settings**
  - Description clear and concise
  - Website URL set (if applicable)
  - Topics/tags added for discoverability
  - Default branch correct (usually `main`)

- [ ] **Features Enabled/Disabled**
  - Issues: Enabled (for bug reports)
  - Discussions: Enabled (for community questions)
  - Wiki: Disabled (avoid fragmented docs)
  - Projects: As needed
  - Sponsors: As needed

- [ ] **Branch Protection** (if applicable)
  - Protect main branch from force pushes
  - Require PR reviews (if team project)
  - Require status checks (if using CI/CD)

---

### 7. Final Verification

- [ ] **Clone Fresh Copy**
  - Clone repository to new directory
  - Verify setup instructions work
  - Check for broken links
  - Test installation process

- [ ] **External Review** (if available)
  - Have someone else review README
  - Test installation on different machine
  - Check for clarity and completeness

- [ ] **Search for Sensitive Terms**
  ```bash
  # Search for common sensitive patterns
  git grep -i "password"
  git grep -i "api.key"
  git grep -i "secret"
  git grep -i "token"
  git grep -i "TODO.*not ready"
  ```

---

## Publication Process

### Making Repository Public

1. **Backup current state**
   ```bash
   git push --all origin  # Push all branches
   git push --tags origin # Push all tags
   ```

2. **GitHub Settings → Danger Zone**
   - Click "Change repository visibility"
   - Select "Make public"
   - Type repository name to confirm
   - Click "I understand, make this repository public"

3. **Verify public visibility**
   - Open repository in incognito/private browser
   - Verify README displays correctly
   - Check all navigation links work

### Post-Publication

- [ ] **Announce Release** (if applicable)
  - Social media posts
  - Blog post or announcement
  - Relevant communities (Reddit, HN, forums)
  - Email lists or newsletters

- [ ] **Monitor Initial Feedback**
  - Watch for first issues/questions
  - Respond promptly to build community trust
  - Fix any obvious problems quickly

- [ ] **Document Process**
  - Update this checklist with lessons learned
  - Note any steps that were missed
  - Improve for next publication

---

## Rollback Plan

If publication reveals problems:

1. **Minor issues (typos, broken links)**
   - Fix quickly and push
   - No need to unpublish

2. **Major issues (security, sensitive data)**
   - Make repository private immediately
   - Fix issue thoroughly
   - Review entire checklist again
   - Republish when safe

3. **Accidental exposure of secrets**
   - Rotate all exposed credentials immediately
   - Make repository private
   - Use tools like `git-filter-repo` to remove from history
   - Force push cleaned history (destructive!)

---

## Lessons Learned

### 2026-02-13 - Plugin Light v1.0.0 Publication

**What went well:**
- Systematic review via TASK-129 work item
- README-DRAFT approach allowed review before replacing
- Branding verification caught URL inconsistencies
- CONTRIBUTING.md set clear expectations

**What to improve:**
- Start with this checklist next time (created after the fact)
- Consider automated link checking (dead link detector)
- Test plugin installation from marketplace perspective

**Notes:**
- Exposing project-hub/ was controversial but added transparency
- "Dogfooding" explanation in README helped frame it positively
- Conservative contribution policy (Model 1) felt right for v1.0

---

**Last Updated:** 2026-02-13
**Template Version:** 1.0
**Usage:** Reference this checklist before making any repository public
