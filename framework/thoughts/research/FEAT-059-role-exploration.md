# FEAT-059: Comprehensive Role Exploration

**Purpose:** Brainstorm and catalog potential AI roles with their mindsets at both Senior and Mid-Level experience tiers.

**Created:** 2026-01-16
**Status:** Research/Exploration
**Related:** [FEAT-059-context-aware-ai-roles.md](../work/backlog/FEAT-059-context-aware-ai-roles.md)

---

## Design Principles

1. **No Junior/Novice Tier** - We want excellence and experience from the start. The framework should encourage best practices, not accommodate learning curves.

2. **Senior vs Mid-Level Distinction:**
   - **Mid-Level:** Competent execution within established boundaries. Follows standards, delivers quality work, raises obvious concerns.
   - **Senior:** Broader judgment, challenges assumptions, considers long-term implications, willing to say "we shouldn't do this."

3. **Deliverable Coverage:** Roles must support both:
   - **Code deliverables** (applications, libraries, tools)
   - **Documentation deliverables** (policies, frameworks, specifications)

---

## Role Catalog

### Technical Roles

#### Developer

| Aspect | Mid-Level | Senior |
|--------|-----------|--------|
| **Focus** | Correctness, functionality, immediate task | Maintainability, patterns, system implications |
| **Code Review** | Catches bugs, style issues, obvious problems | Questions design choices, identifies tech debt, suggests alternatives |
| **Scope** | Assigned work | Assigned work + adjacent concerns |
| **Risk Awareness** | Obvious risks, known vulnerabilities | Subtle risks, precedent-setting concerns, future maintenance burden |
| **Pushback** | On clear violations | On questionable approaches, even when technically valid |
| **Mindset** | "Does this work correctly and follow our standards?" | "Is this the right approach? What are we trading off? Will we regret this?" |

---

#### Architect

| Aspect | Mid-Level | Senior |
|--------|-----------|--------|
| **Focus** | System design, component interaction | Strategic alignment, organizational impact, technology direction |
| **Decisions** | Makes design choices within established patterns | Establishes patterns, challenges architectural assumptions |
| **Scope** | Single system or service | Cross-system, enterprise-wide implications |
| **Trade-offs** | Documents known trade-offs | Identifies hidden trade-offs, questions whether the problem is correctly framed |
| **Time Horizon** | 1-2 years | 3-5+ years, considers technology evolution |
| **Pushback** | On designs that violate principles | On solving the wrong problem, premature optimization, over-engineering |
| **Mindset** | "How should we build this to meet requirements?" | "Should we build this at all? What's the simplest thing that could work? What will we wish we'd done differently?" |

---

#### Security Analyst

| Aspect | Mid-Level | Senior |
|--------|-----------|--------|
| **Focus** | Vulnerability identification, compliance checking | Threat modeling, attack surface analysis, security architecture |
| **Scope** | Code and configuration | System-wide, supply chain, operational security |
| **Standards** | OWASP Top 10, known CVEs | Defense in depth, zero trust principles, emerging threat landscape |
| **Risk Assessment** | Severity classification | Business impact, exploitability, attack chain analysis |
| **Pushback** | On clear vulnerabilities | On features that increase attack surface, even when "necessary" |
| **Mindset** | "What vulnerabilities exist? Are we compliant?" | "How would I attack this? What assumptions are we making about trust? Should this feature exist given the security cost?" |

---

#### QA Engineer / Test Specialist

| Aspect | Mid-Level | Senior |
|--------|-----------|--------|
| **Focus** | Test coverage, bug identification, test automation | Test strategy, quality culture, risk-based testing |
| **Scope** | Feature testing, regression suites | End-to-end quality, non-functional requirements, testability design |
| **Approach** | Execute test plans, write test cases | Design test strategies, identify what's not being tested |
| **Risk Assessment** | Test coverage metrics | Business risk prioritization, edge case identification |
| **Pushback** | On insufficient test coverage | On untestable designs, on shipping without adequate confidence |
| **Mindset** | "Is this tested? Do the tests pass?" | "What could go wrong that we haven't thought of? Are we testing the right things? What's our confidence level?" |

---

#### DevOps / Platform Engineer

| Aspect | Mid-Level | Senior |
|--------|-----------|--------|
| **Focus** | CI/CD pipelines, deployment automation, infrastructure | Platform strategy, reliability engineering, developer experience |
| **Scope** | Build and deploy processes | Operational excellence, observability, incident response |
| **Standards** | Working pipelines, documented processes | Infrastructure as code, immutable deployments, chaos engineering |
| **Risk Assessment** | Deployment failures, rollback plans | Blast radius, cascading failures, operational burden |
| **Pushback** | On undeployable code | On designs that are operationally expensive, on complexity without observability |
| **Mindset** | "Can we build and deploy this reliably?" | "Can we operate this at 3am? What happens when it fails? Are we creating operational debt?" |

---

#### Database Administrator / Data Engineer

| Aspect | Mid-Level | Senior |
|--------|-----------|--------|
| **Focus** | Schema design, query optimization, data integrity | Data architecture, scalability, data governance |
| **Scope** | Database performance, backups, migrations | Data strategy, cross-system data flow, compliance |
| **Standards** | Normalization, indexing, query performance | Data modeling patterns, eventual consistency, CAP theorem trade-offs |
| **Risk Assessment** | Data loss, query performance | Data corruption, migration failures, compliance violations |
| **Pushback** | On poor schema design | On data models that won't scale, on denormalization without justification |
| **Mindset** | "Is this schema correct? Are queries performant?" | "How will this data model evolve? What are the consistency guarantees? What happens at 10x scale?" |

---

#### Performance Engineer

| Aspect | Mid-Level | Senior |
|--------|-----------|--------|
| **Focus** | Benchmarking, profiling, optimization | Performance architecture, capacity planning, SLO design |
| **Scope** | Component-level performance | System-wide performance, user-perceived latency, cost efficiency |
| **Approach** | Measure and optimize hot paths | Design for performance, identify systemic bottlenecks |
| **Risk Assessment** | Performance regressions | Scalability cliffs, resource exhaustion, cascading slowdowns |
| **Pushback** | On obviously slow code | On architectures with inherent performance limits |
| **Mindset** | "Is this fast enough? Where are the bottlenecks?" | "What are our performance requirements? What will break first under load? Are we optimizing the right thing?" |

---

#### Technical Writer / Documentation Specialist

| Aspect | Mid-Level | Senior |
|--------|-----------|--------|
| **Focus** | Clear writing, accurate documentation, style consistency | Information architecture, documentation strategy, user experience |
| **Scope** | Individual documents, API references | Documentation systems, discoverability, maintenance burden |
| **Standards** | Grammar, clarity, completeness | Audience analysis, progressive disclosure, documentation as product |
| **Risk Assessment** | Outdated docs, unclear instructions | Documentation debt, knowledge silos, onboarding friction |
| **Pushback** | On unclear or incomplete docs | On undocumentable features, on documentation that will never be maintained |
| **Mindset** | "Is this clear and correct?" | "Will users find this? Will it stay current? Are we documenting the right things?" |

---

### Process & Management Roles

#### Scrum Master / Agile Coach

| Aspect | Mid-Level | Senior |
|--------|-----------|--------|
| **Focus** | Process facilitation, ceremony execution, impediment removal | Team health, continuous improvement, organizational agility |
| **Scope** | Team workflow, sprint execution | Cross-team coordination, process evolution, culture change |
| **Standards** | Workflow rules, WIP limits, transition policies | Agile principles over practices, context-appropriate process |
| **Risk Assessment** | Workflow violations, blocked items | Process theater, team dysfunction, sustainability |
| **Pushback** | On process violations | On processes that aren't serving the team, on ceremony without value |
| **Mindset** | "Is the process being followed? What's blocked?" | "Is this process helping? What's the team really struggling with? Are we doing agile or being agile?" |

---

#### Release Manager

| Aspect | Mid-Level | Senior |
|--------|-----------|--------|
| **Focus** | Version control, release coordination, changelog maintenance | Release strategy, deployment risk, rollback planning |
| **Scope** | Individual releases, version numbering | Release cadence, feature flags, progressive rollout |
| **Standards** | Semantic versioning, atomic commits, release notes | Release quality gates, go/no-go criteria, incident response |
| **Risk Assessment** | Version conflicts, incomplete releases | Release failures, customer impact, recovery time |
| **Pushback** | On unversioned changes, incomplete changelogs | On risky releases, on shipping without rollback plan |
| **Mindset** | "Is this release properly versioned and documented?" | "Should we release this now? What's the blast radius if it fails? Do we have confidence?" |

---

#### Product Owner / Product Manager

| Aspect | Mid-Level | Senior |
|--------|-----------|--------|
| **Focus** | Requirements definition, backlog prioritization, acceptance criteria | Product strategy, market fit, stakeholder alignment |
| **Scope** | Feature delivery, user stories | Product vision, roadmap, competitive positioning |
| **Standards** | Clear requirements, measurable outcomes | Jobs-to-be-done, outcome over output, validated learning |
| **Risk Assessment** | Scope creep, unclear requirements | Building the wrong thing, opportunity cost, market timing |
| **Pushback** | On unclear requirements | On features without clear user value, on building for hypothetical users |
| **Mindset** | "What does the user need? Is this requirement clear?" | "Why do users need this? What problem are we really solving? What shouldn't we build?" |

---

#### Project Manager

| Aspect | Mid-Level | Senior |
|--------|-----------|--------|
| **Focus** | Task tracking, timeline management, status reporting | Program management, risk mitigation, stakeholder management |
| **Scope** | Project execution, resource coordination | Cross-project dependencies, portfolio prioritization |
| **Standards** | On-time delivery, scope management, communication | Realistic planning, constraint management, expectation setting |
| **Risk Assessment** | Schedule slippage, resource conflicts | Project failure modes, organizational blockers |
| **Pushback** | On unrealistic timelines | On projects set up to fail, on scope without resources |
| **Mindset** | "Is the project on track? What's the status?" | "Can this project succeed? What aren't we talking about? What needs to be true for this to work?" |

---

### Business & Strategic Roles

#### Business Analyst

| Aspect | Mid-Level | Senior |
|--------|-----------|--------|
| **Focus** | Requirements gathering, process documentation, stakeholder interviews | Business process optimization, strategic alignment, change management |
| **Scope** | Feature requirements, workflow mapping | Business capability modeling, cross-functional impact |
| **Standards** | Clear requirements, traceability | Business value quantification, outcome measurement |
| **Risk Assessment** | Missed requirements, stakeholder conflicts | Process disruption, adoption failure, organizational resistance |
| **Pushback** | On incomplete requirements | On solutions that don't address root cause, on automating broken processes |
| **Mindset** | "What does the business need? Are requirements complete?" | "Why does the business think it needs this? What's the real problem? Is technology the right solution?" |

---

#### Financial Analyst / CFO Perspective

| Aspect | Mid-Level | Senior |
|--------|-----------|--------|
| **Focus** | Cost tracking, budget management, ROI calculation | Financial strategy, investment prioritization, risk-adjusted returns |
| **Scope** | Project costs, operational expenses | Total cost of ownership, opportunity cost, long-term financial impact |
| **Standards** | Budget adherence, cost reporting | Financial modeling, scenario analysis, value stream accounting |
| **Risk Assessment** | Budget overruns, unexpected costs | Financial sustainability, vendor lock-in costs, technical debt valuation |
| **Pushback** | On budget violations | On investments without clear returns, on hidden costs |
| **Mindset** | "What does this cost? Are we within budget?" | "What's the true cost including maintenance? What's the return? What else could we do with this money?" |

---

#### Compliance Officer

| Aspect | Mid-Level | Senior |
|--------|-----------|--------|
| **Focus** | Regulatory compliance, audit preparation, policy adherence | Compliance strategy, regulatory relationship, risk-based compliance |
| **Scope** | Specific regulations (GDPR, SOX, HIPAA) | Compliance program design, cross-regulation optimization |
| **Standards** | Checklist compliance, documentation | Spirit of regulations, proactive compliance, competitive advantage through trust |
| **Risk Assessment** | Compliance gaps, audit findings | Regulatory trends, enforcement priorities, reputational risk |
| **Pushback** | On clear violations | On "technically compliant" approaches that miss the point |
| **Mindset** | "Are we compliant with requirements?" | "Are we building trust? What's the regulatory direction? How do we make compliance a feature?" |

---

#### UX Designer / User Researcher

| Aspect | Mid-Level | Senior |
|--------|-----------|--------|
| **Focus** | Interface design, usability testing, accessibility compliance | Design systems, user research strategy, experience architecture |
| **Scope** | Screen/feature design, user flows | End-to-end experience, cross-channel consistency, design operations |
| **Standards** | WCAG compliance, design patterns, usability heuristics | Inclusive design, emotional design, measuring user success |
| **Risk Assessment** | Usability issues, accessibility gaps | User abandonment, trust erosion, competitive disadvantage |
| **Pushback** | On unusable interfaces | On features users don't want, on "user-hostile" patterns |
| **Mindset** | "Can users accomplish their goals?" | "Should users want to accomplish this goal? What are we optimizing for? Are we being honest with users?" |

---

### Executive Perspectives

#### CEO Perspective

| Aspect | Mid-Level (Director-level) | Senior (C-level) |
|--------|----------------------------|------------------|
| **Focus** | Departmental alignment, execution excellence | Organizational direction, market positioning, stakeholder value |
| **Scope** | Functional area success | Enterprise-wide impact, ecosystem relationships |
| **Standards** | Operational metrics, team performance | Strategic outcomes, sustainable competitive advantage |
| **Risk Assessment** | Departmental risks, resource constraints | Existential risks, market disruption, organizational resilience |
| **Pushback** | On misaligned initiatives | On strategies that don't serve the mission, on short-term thinking |
| **Mindset** | "Does this support our goals?" | "Is this who we want to be? What's our responsibility to stakeholders? What will we wish we'd done?" |

---

#### CTO Perspective

| Aspect | Mid-Level (Engineering Director) | Senior (C-level) |
|--------|----------------------------------|------------------|
| **Focus** | Technical execution, team leadership, delivery | Technology strategy, innovation, technical culture |
| **Scope** | Engineering organization, technical quality | Technology as business enabler, build vs buy, technical vision |
| **Standards** | Engineering excellence, technical debt management | Technology investment thesis, platform thinking |
| **Risk Assessment** | Technical risks, talent retention | Technology disruption, architectural obsolescence, security posture |
| **Pushback** | On poor technical decisions | On technology for technology's sake, on following trends without strategy |
| **Mindset** | "Are we building well?" | "Are we building the right things? Is our technology enabling or constraining the business?" |

---

### Support & Operations Roles

#### Support Engineer / Customer Success

| Aspect | Mid-Level | Senior |
|--------|-----------|--------|
| **Focus** | Issue resolution, customer communication, knowledge base | Support strategy, escalation design, customer health |
| **Scope** | Individual tickets, immediate problems | Support operations, customer patterns, product feedback loop |
| **Standards** | Resolution time, customer satisfaction | Support as product input, proactive support, self-service enablement |
| **Risk Assessment** | Unresolved issues, unhappy customers | Churn patterns, support scalability, knowledge gaps |
| **Pushback** | On unsupportable features | On shipping without support readiness, on ignoring support signals |
| **Mindset** | "Can we help this customer?" | "Why are customers struggling? What does support volume tell us about the product?" |

---

#### Change Manager

| Aspect | Mid-Level | Senior |
|--------|-----------|--------|
| **Focus** | Change communication, training, adoption tracking | Change strategy, organizational readiness, cultural transformation |
| **Scope** | Individual change initiatives | Portfolio of changes, change capacity, sustainable pace |
| **Standards** | Change management frameworks, stakeholder analysis | Organizational psychology, resistance patterns, lasting change |
| **Risk Assessment** | Adoption failure, resistance | Change fatigue, organizational trauma, cynicism |
| **Pushback** | On poorly communicated changes | On changes without organizational capacity, on underestimating human factors |
| **Mindset** | "How do we roll this out?" | "Is the organization ready? What else is changing? How do we make this stick?" |

---

#### Risk Manager

| Aspect | Mid-Level | Senior |
|--------|-----------|--------|
| **Focus** | Risk identification, mitigation planning, risk registers | Risk strategy, enterprise risk management, risk culture |
| **Scope** | Project/operational risks | Strategic risks, interconnected risks, emerging risks |
| **Standards** | Risk matrices, probability/impact analysis | Risk appetite definition, scenario planning, resilience |
| **Risk Assessment** | Known risks, standard categories | Unknown unknowns, systemic risks, black swan preparation |
| **Pushback** | On unmitigated risks | On risk theater, on optimism bias, on ignoring uncomfortable risks |
| **Mindset** | "What are the risks? Do we have mitigation plans?" | "What are we not seeing? What assumptions are we making? What would have to be true for this to fail catastrophically?" |

---

## Summary Table

| Role | Primary Domain | Code Focus | Documentation Focus |
|------|---------------|------------|---------------------|
| Developer | Technical | High | Low |
| Architect | Technical | Medium | High |
| Security Analyst | Technical | High | Medium |
| QA Engineer | Technical | High | Medium |
| DevOps Engineer | Technical | High | Medium |
| DBA/Data Engineer | Technical | High | Medium |
| Performance Engineer | Technical | High | Low |
| Technical Writer | Documentation | Low | High |
| Scrum Master | Process | Low | Medium |
| Release Manager | Process | Medium | High |
| Product Owner | Business | Low | High |
| Project Manager | Process | Low | High |
| Business Analyst | Business | Low | High |
| Financial Analyst | Business | Low | High |
| Compliance Officer | Governance | Low | High |
| UX Designer | Design | Low | High |
| CEO Perspective | Strategy | Low | High |
| CTO Perspective | Strategy | Medium | High |
| Support Engineer | Operations | Low | High |
| Change Manager | Process | Low | High |
| Risk Manager | Governance | Low | High |

---

## Notes for Narrowing Down

When selecting which roles to include in the framework:

1. **Core vs Extended:** Which roles are essential for most projects vs. specialized?
2. **Overlap:** Where do roles have significant overlap that could be consolidated?
3. **Activation Cost:** Some roles may be expensive to "activate" (require significant context). Worth the cost?
4. **Natural Combinations:** Some roles naturally pair (e.g., Developer + Security Analyst for secure coding)

---

## Lifecycle Analysis: Two Core Scenarios

### Application Development Lifecycle

| Phase | Typical Personas Involved |
|-------|---------------------------|
| **Ideation/Discovery** | Product Owner, Business Analyst, UX Designer |
| **Planning** | Scrum Master, Architect, Project Manager |
| **Design** | Architect, UX Designer, Security Analyst |
| **Implementation** | Developer, DBA/Data Engineer |
| **Testing** | QA Engineer, Security Analyst, Performance Engineer |
| **Deployment** | DevOps Engineer, Release Manager |
| **Operations** | Support Engineer, DevOps Engineer |
| **Iteration** | All of the above, cycling |

### Policy Development Lifecycle

| Phase | Typical Personas Involved |
|-------|---------------------------|
| **Need Identification** | Compliance Officer, Risk Manager, Executive (CEO/CTO) |
| **Research/Analysis** | Subject Matter Expert, Business Analyst, Legal Counsel |
| **Drafting** | Technical Writer, Subject Matter Expert |
| **Review** | Stakeholder Representatives, Compliance Officer, Legal Counsel |
| **Approval** | Executive (CEO/CTO/CFO depending on domain) |
| **Communication** | Change Manager, Technical Writer |
| **Enforcement/Monitoring** | Compliance Officer, Auditor |
| **Revision** | Cycles back through |

---

## Additional Roles Identified Through Lifecycle Analysis

### Subject Matter Expert (SME)

| Aspect | Mid-Level | Senior |
|--------|-----------|--------|
| **Focus** | Domain accuracy, technical correctness in specialty area | Domain strategy, cross-domain implications, industry direction |
| **Scope** | Specific technical or business domain | Domain ecosystem, emerging practices, organizational knowledge |
| **Standards** | Current best practices, known patterns | Evolving standards, research-backed approaches |
| **Risk Assessment** | Technical inaccuracies, domain-specific pitfalls | Domain obsolescence, competitive disadvantage, missed opportunities |
| **Pushback** | On factual errors, outdated practices | On fundamental misunderstandings, on ignoring domain complexity |
| **Mindset** | "Is this technically accurate for our domain?" | "Does this reflect deep domain understanding? What nuances are being missed? How is this domain evolving?" |

**Note:** SME is distinct from other roles because:
- Not necessarily a decision-maker
- Deep domain knowledge in a specific area (could be security, HR, finance, legal, healthcare, etc.)
- Validates accuracy, not just process or quality
- Often consulted rather than driving

---

### Legal Counsel

| Aspect | Mid-Level | Senior |
|--------|-----------|--------|
| **Focus** | Contract review, compliance checking, liability identification | Legal strategy, regulatory navigation, risk-balanced guidance |
| **Scope** | Specific agreements, clear legal requirements | Enterprise legal posture, proactive legal design |
| **Standards** | Statutory compliance, standard contract terms | Legal defensibility, regulatory relationship management |
| **Risk Assessment** | Clear legal violations, liability exposure | Litigation risk, regulatory action, reputational damage |
| **Pushback** | On clearly illegal or high-risk actions | On legally risky strategies even when technically permissible |
| **Mindset** | "Is this legal? What are we agreeing to?" | "What's our legal exposure? How do we achieve the goal while managing legal risk? What precedent does this set?" |

---

### Auditor

| Aspect | Mid-Level | Senior |
|--------|-----------|--------|
| **Focus** | Evidence gathering, control testing, finding documentation | Audit strategy, risk-based audit planning, systemic findings |
| **Scope** | Specific controls, defined audit areas | Audit program design, cross-functional audit scope |
| **Standards** | Audit procedures, sampling methodology, documentation standards | Professional skepticism, materiality judgment, audit quality |
| **Risk Assessment** | Control failures, documentation gaps | Systemic weaknesses, fraud indicators, management override |
| **Pushback** | On missing evidence, incomplete controls | On management explanations that don't add up, on scope limitations |
| **Mindset** | "Can we verify this? Is there evidence?" | "What story does the evidence tell? What's not being said? What would a reasonable third party conclude?" |

---

### User Advocate / End User Perspective

| Aspect | Mid-Level | Senior |
|--------|-----------|--------|
| **Focus** | User task completion, obvious usability issues, accessibility | User journey holistically, emotional experience, user trust |
| **Scope** | Feature usability, immediate user experience | End-to-end experience, user relationship over time |
| **Standards** | Task success, error prevention, learnability | User empowerment, delight, long-term user value |
| **Risk Assessment** | User confusion, task failure, accessibility barriers | User abandonment, trust erosion, user harm |
| **Pushback** | On confusing interfaces, user-hostile flows | On features that exploit users, on dark patterns, on ignoring user feedback |
| **Mindset** | "Can users accomplish their goal?" | "Should users want to accomplish this goal the way we've designed it? Are we respecting users? What would I want if I were the user?" |

**Note:** User Advocate is distinct from UX Designer:
- UX Designer creates/designs the experience
- User Advocate evaluates from the user's perspective
- User Advocate can represent specific user personas during review
- Closer to "user testing" mindset than "design" mindset

---

## Role Categories by Function

Reorganizing roles by their primary function in the lifecycle:

### Creation Roles (Build Things)

| Role | Creates |
|------|---------|
| Developer | Code, features, implementations |
| Architect | System designs, technical specifications |
| Technical Writer | Documentation, guides, policies |
| UX Designer | Interfaces, user experiences, design systems |
| DBA/Data Engineer | Data models, schemas, data pipelines |

### Validation Roles (Verify Quality)

| Role | Validates |
|------|-----------|
| QA Engineer | Functional correctness, test coverage |
| Security Analyst | Security posture, vulnerability absence |
| Performance Engineer | Speed, scalability, efficiency |
| Auditor | Compliance, control effectiveness, evidence |
| Subject Matter Expert | Domain accuracy, technical correctness |
| User Advocate | User experience, usability, accessibility |

### Governance Roles (Enforce Process)

| Role | Governs |
|------|---------|
| Scrum Master | Workflow, process adherence, team health |
| Release Manager | Versioning, release quality, deployment |
| Compliance Officer | Regulatory adherence, policy compliance |
| Legal Counsel | Legal compliance, contractual obligations |

### Strategy Roles (Set Direction)

| Role | Directs |
|------|---------|
| Product Owner | Product vision, feature prioritization |
| Business Analyst | Requirements, business process optimization |
| CEO Perspective | Organizational direction, stakeholder value |
| CTO Perspective | Technology strategy, technical vision |
| Financial Analyst | Investment priorities, cost/benefit decisions |

### Operations Roles (Keep Things Running)

| Role | Operates |
|------|----------|
| DevOps Engineer | Infrastructure, deployments, reliability |
| Support Engineer | Issue resolution, customer success |
| Change Manager | Organizational adoption, transition management |
| Risk Manager | Risk identification, mitigation planning |

### Perspective Roles (Represent Viewpoints)

| Role | Represents |
|------|------------|
| User Advocate | End user perspective, user needs |
| Subject Matter Expert | Domain expertise, specialized knowledge |

---

## Updated Summary Table

| Role | Primary Domain | Code Focus | Documentation Focus | Category |
|------|---------------|------------|---------------------|----------|
| Developer | Technical | High | Low | Creation |
| Architect | Technical | Medium | High | Creation |
| Technical Writer | Documentation | Low | High | Creation |
| UX Designer | Design | Low | High | Creation |
| DBA/Data Engineer | Technical | High | Medium | Creation |
| QA Engineer | Technical | High | Medium | Validation |
| Security Analyst | Technical | High | Medium | Validation |
| Performance Engineer | Technical | High | Low | Validation |
| Auditor | Governance | Low | High | Validation |
| Subject Matter Expert | Varies | Varies | Varies | Validation/Perspective |
| User Advocate | Design | Low | Medium | Validation/Perspective |
| Scrum Master | Process | Low | Medium | Governance |
| Release Manager | Process | Medium | High | Governance |
| Compliance Officer | Governance | Low | High | Governance |
| Legal Counsel | Governance | Low | High | Governance |
| Product Owner | Business | Low | High | Strategy |
| Business Analyst | Business | Low | High | Strategy |
| Financial Analyst | Business | Low | High | Strategy |
| CEO Perspective | Strategy | Low | High | Strategy |
| CTO Perspective | Strategy | Medium | High | Strategy |
| DevOps Engineer | Technical | High | Medium | Operations |
| Support Engineer | Operations | Low | High | Operations |
| Change Manager | Process | Low | High | Operations |
| Risk Manager | Governance | Low | High | Operations |
| Project Manager | Process | Low | High | Strategy |

**Total: 25 roles cataloged**

---

## Development Strategy Phases

How should a human or AI approach building an application? This maps phases to typical roles.

| Phase | Purpose | Key Activities | Primary Roles |
|-------|---------|----------------|---------------|
| **1. Research** | Understand the problem space | Technology evaluation, existing solutions, constraints, feasibility | Architect, SME, Developer |
| **2. Requirements** | Define what success looks like | User stories, acceptance criteria, scope boundaries | Product Owner, Business Analyst, User Advocate |
| **3. Design** | Plan the solution | Architecture, data models, interfaces, dependencies | Architect, UX Designer, Security Analyst, DBA |
| **4. MVP** | Prove it can work | Core functionality, happy path, minimal viable implementation | Developer |
| **5. Tests** | Establish quality baseline | Unit tests, integration tests, define what "working" means | QA Engineer, Developer |
| **6. Refactor** | Improve internal quality | Code organization, naming, duplication removal, patterns | Developer, Architect |
| **7. Harden** | Make it production-ready | Error handling, edge cases, input validation, logging | Developer, QA Engineer |
| **8. Security** | Protect against threats | Authentication, authorization, input sanitization, secrets management | Security Analyst, Developer |
| **9. Performance** | Optimize efficiency | Profiling, caching, query optimization, resource management | Performance Engineer, Developer, DBA |
| **10. Documentation** | Enable others | API docs, README, inline comments where needed, runbooks | Technical Writer, Developer |
| **11. Review** | External validation | Code review, security review, architecture review | All Validation Roles, Architect |
| **12. Deploy** | Ship it | CI/CD, environment config, monitoring, rollback plan | DevOps Engineer, Release Manager |

### Phase Notes

**These aren't always sequential:**
- You might establish tests before MVP (TDD approach)
- Security should be considered throughout, not just as a phase
- Review can happen at multiple points, not just at the end

**Different projects need different emphasis:**
- Internal tool → might skip hardening depth
- Financial app → front-load security
- Prototype → stop after MVP
- Library → heavy emphasis on documentation and API design

**Phase vs Role relationship:**
- Some roles span many phases (Developer)
- Some roles focus on specific phases (Release Manager → Deploy)
- Some roles are "always on" consultants (Security Analyst, Architect)

### Mapping to AI Role Activation

When a user says "let's work on X," the phase implies which role mindset to activate:

| User Says | Implied Phase | Suggested Role |
|-----------|---------------|----------------|
| "Research how to implement caching" | Research | Architect or SME |
| "What should this feature do?" | Requirements | Product Owner, Business Analyst |
| "Design the API for this" | Design | Architect |
| "Just get it working" | MVP | Developer |
| "Add tests for this" | Tests | QA Engineer or Developer |
| "Clean up this code" | Refactor | Developer |
| "Handle edge cases" | Harden | Developer |
| "Review this for security issues" | Security | Security Analyst |
| "This is too slow" | Performance | Performance Engineer |
| "Document how this works" | Documentation | Technical Writer |
| "Review my code" | Review | Developer (Senior), Architect |
| "Deploy this" | Deploy | DevOps Engineer, Release Manager |

---

## Documentation Strategy Phases

How should a human or AI approach building documentation or policy? This maps phases to typical roles.

| Phase | Purpose | Key Activities | Primary Roles |
|-------|---------|----------------|---------------|
| **1. Research** | Understand the need | Why is this document needed? What exists? Who's the audience? What's the scope? | SME, Business Analyst |
| **2. Requirements** | Define what success looks like | Audience needs, compliance requirements, approval criteria, format constraints | Product Owner, Compliance Officer, Legal Counsel |
| **3. Outline/Structure** | Plan the document | Information architecture, section flow, dependencies between sections | Technical Writer, Architect |
| **4. Draft** | Get content down | First pass, capture knowledge, don't over-polish | Writer (Draft variant) |
| **5. SME Review** | Validate accuracy | Subject matter experts verify technical correctness | SME Reviewer |
| **6. Editorial Review** | Improve quality | Clarity, consistency, grammar, style guide adherence | Editorial Reviewer |
| **7. Stakeholder Review** | Validate fit for purpose | Does it meet the need? Is it usable? Any gaps? | Stakeholder Reviewer, User Advocate |
| **8. Legal/Compliance Review** | Ensure safety | Regulatory compliance, liability, policy alignment | Legal Reviewer, Compliance Officer |
| **9. Revision** | Incorporate feedback | Address review comments, reconcile conflicts | Writer |
| **10. Approval** | Get sign-off | Appropriate authority approves for release | Executive (CEO/CTO/CFO) |
| **11. Publication** | Release it | Format, distribute, announce, train | Change Manager, Technical Writer |
| **12. Maintenance** | Keep it current | Version control, periodic review, deprecation | Maintenance Writer |

### Documentation Phase Notes

**Documentation has more review phases than code:**
- Code has tests as automated validation
- Documentation relies on human review cycles
- Multiple reviewer types with different concerns

**Approval/Authority matters more:**
- Documentation (especially policy) often requires formal sign-off
- Code typically just needs to pass tests and code review

**Maintenance is often neglected:**
- Both code and docs suffer from "write once, forget forever" syndrome
- Documentation may be worse - no "tests" to fail when it becomes outdated

---

## Role Variants Approach

Instead of "Role + Phase," we can define specialized role variants with baked-in mindsets. This feels more natural than tracking two dimensions.

### Developer Variants

| Variant | Mindset | When Activated |
|---------|---------|----------------|
| **Prototype Developer** | "Get it working, don't overthink. Speed over polish. Prove the concept." | MVP, spikes, experiments |
| **Production Developer** | "This needs to be maintainable, tested, and robust. Handle errors gracefully." | Feature development, hardening |
| **Refactoring Developer** | "Improve structure without changing behavior. Small steps, keep tests green." | Tech debt, code cleanup |
| **Performance Developer** | "Measure first, optimize bottlenecks, don't prematurely optimize." | Performance work |
| **Security-Focused Developer** | "How could this be exploited? Validate inputs, sanitize outputs, least privilege." | Security hardening |
| **Test Developer** | "What could break? Cover edge cases. Tests document intent." | Test writing, TDD |
| **Maintenance Developer** | "Understand before changing. Minimize blast radius. Don't break existing behavior." | Bug fixes, legacy code |
| **API Developer** | "Design for the consumer. Consistency, discoverability, backwards compatibility." | API design, library development |

### Writer Variants

| Variant | Mindset | When Activated |
|---------|---------|----------------|
| **Draft Writer** | "Get it down, don't over-polish. Capture the knowledge first." | Initial drafting, brain dumps |
| **Technical Writer** | "Accuracy, precision, completeness. The reader needs to do something with this." | Procedures, API docs, specifications |
| **Policy Writer** | "Authority, enforceability, clarity of obligations. What MUST happen?" | Policies, standards, requirements |
| **Editorial Writer** | "Clarity, flow, consistency. Is this readable and professional?" | Review, revision, style enforcement |
| **User Guide Writer** | "Can the reader accomplish their goal? Task-oriented, progressive disclosure." | End-user documentation, tutorials |
| **Executive Writer** | "Brevity, impact, decision-enablement. What does leadership need to know?" | Executive summaries, board reports |
| **Compliance Writer** | "Evidence, traceability, audit-readiness. Can we prove we did this?" | Compliance documentation, audit trails |
| **Training Writer** | "Learning objectives, scaffolding, assessment. Will they remember this?" | Training materials, onboarding docs |
| **Maintenance Writer** | "What's changed? What's obsolete? Keep it current without breaking references." | Updates, deprecation, versioning |

### Reviewer Variants

| Variant | Mindset | When Activated |
|---------|---------|----------------|
| **SME Reviewer** | "Is this factually correct? Are there inaccuracies or oversimplifications?" | Technical accuracy review |
| **Editorial Reviewer** | "Is this clear, consistent, and well-written?" | Quality/style review |
| **Stakeholder Reviewer** | "Does this serve my needs? Is anything missing?" | Fit-for-purpose review |
| **Legal Reviewer** | "Is this compliant? Does it create liability? Is it enforceable?" | Legal/compliance review |
| **User Reviewer** | "Can I actually use this? Is it understandable to the target audience?" | Usability review |
| **Code Reviewer** | "Is this correct, maintainable, and following our standards?" | Code review |
| **Security Reviewer** | "What could be exploited? What's the attack surface?" | Security review |
| **Architecture Reviewer** | "Does this fit the system? What are the long-term implications?" | Design/architecture review |

### Architect Variants

| Variant | Mindset | When Activated |
|---------|---------|----------------|
| **Solution Architect** | "How do we solve this specific problem within our constraints?" | Project-level design |
| **Enterprise Architect** | "How does this fit the broader technology landscape? What are the organizational implications?" | Cross-system, strategic design |
| **Security Architect** | "What's the threat model? How do we design for defense in depth?" | Security design |
| **Data Architect** | "How does data flow? What are the consistency, integrity, and governance requirements?" | Data modeling, integration |
| **Integration Architect** | "How do systems talk to each other? What are the contracts and failure modes?" | API design, system integration |

### Analyst Variants

| Variant | Mindset | When Activated |
|---------|---------|----------------|
| **Business Analyst** | "What does the business need? How do we translate that to requirements?" | Requirements gathering |
| **Data Analyst** | "What does the data tell us? How do we extract insight?" | Data analysis, reporting |
| **Security Analyst** | "What are the threats? Where are the vulnerabilities?" | Security assessment |
| **Financial Analyst** | "What does this cost? What's the ROI? Is this a good investment?" | Cost/benefit analysis |
| **Risk Analyst** | "What could go wrong? How likely? How severe? How do we mitigate?" | Risk assessment |

### QA Variants

| Variant | Mindset | When Activated |
|---------|---------|----------------|
| **Manual Tester** | "Can I break this? What happens with unexpected inputs?" | Exploratory testing |
| **Automation Engineer** | "How do we test this reliably and repeatedly? What's the test architecture?" | Test automation |
| **Performance Tester** | "How does this behave under load? Where are the bottlenecks?" | Performance/load testing |
| **Security Tester** | "How would an attacker approach this? What are the OWASP risks?" | Penetration testing, security testing |
| **Accessibility Tester** | "Can users with disabilities use this? Does it meet WCAG standards?" | Accessibility testing |

---

## Comparison: Code vs Documentation Variants

| Code Role | Documentation Parallel | Notes |
|-----------|----------------------|-------|
| Prototype Developer | Draft Writer | Speed over polish, prove the concept |
| Production Developer | Technical Writer | Quality, completeness, maintainability |
| Refactoring Developer | Editorial Writer | Improve without changing meaning |
| Security-Focused Developer | Compliance Writer | Risk awareness, audit trails |
| API Developer | Technical Writer (API focus) | Consumer-focused, contracts |
| Maintenance Developer | Maintenance Writer | Careful updates, don't break things |
| Test Developer | SME Reviewer | Validates correctness (different mechanism) |

---

## Variant Approach: Trade-offs

| Approach | Pros | Cons |
|----------|------|------|
| **Base Role + Phase modifier** | Fewer roles to define; phase is explicit context | Two dimensions to track; base role feels generic |
| **Specific Variants** | Mindset is baked in; single concept to activate; feels natural | More roles to catalog; potential role explosion |
| **Hybrid** | Flexibility; some roles have variants, others don't | Inconsistent model; harder to explain |

**Current leaning:** Variant approach for roles where mindset shifts significantly by context (Developer, Writer, Reviewer, Architect, Analyst, QA). Singular roles for those that don't vary much (Scrum Master, Release Manager, Compliance Officer).

---

## Mapping User Statements to Variants

### Code Project Examples

| User Says | Implied Variant |
|-----------|-----------------|
| "Just get it working" | Prototype Developer |
| "This needs to be production-ready" | Production Developer |
| "Clean up this code" | Refactoring Developer |
| "This is too slow" | Performance Developer |
| "Review this for security" | Security Reviewer or Security-Focused Developer |
| "Add tests for this" | Test Developer |
| "Fix this bug in the legacy code" | Maintenance Developer |
| "Design the API for this" | API Developer or Solution Architect |

### Documentation Project Examples

| User Says | Implied Variant |
|-----------|-----------------|
| "Let's brain dump what we know" | Draft Writer |
| "Write the API documentation" | Technical Writer |
| "Create a policy for X" | Policy Writer |
| "Clean up this document" | Editorial Writer |
| "Write the user guide" | User Guide Writer |
| "Summarize this for the board" | Executive Writer |
| "Check if this is technically accurate" | SME Reviewer |
| "Review for legal issues" | Legal Reviewer |
| "Is this usable for our audience?" | User Reviewer |

---

## Design Decisions

### Decision: Phases Are Documentation, Not Framework Mechanism

**Status:** Decided (2026-01-16)

**Decision:** Project lifecycle phases should be documented as reference material but NOT implemented as a framework activation mechanism.

**Reasoning:**

1. **Users don't think in phases** - Nobody says "I'm in the Harden phase." They say "handle edge cases" or "make this production-ready." The variant approach captures this more naturally.

2. **Phases overlap and interleave** - Real work doesn't follow a clean sequence. You might be hardening one module while prototyping another. Tracking "current phase" would be artificial.

3. **Added complexity without clear benefit** - If we already have variants that capture the mindset ("Production Developer" vs "Prototype Developer"), adding "phase" as a separate dimension doesn't provide additional value.

4. **Variants already encode phase implicitly** - "Prototype Developer" implies MVP phase. "Refactoring Developer" implies refactor phase. The mindset is what matters, and variants capture that.

5. **Too early for this complexity** - The framework needs to prove value with simpler mechanisms first. Phases could be a future enhancement if needed.

**What this means:**

- Phase documentation stays in this research file as reference/context
- Phases help explain *when* variants are typically used
- The framework implementation will focus on role variants, not phase tracking
- AI can use phase knowledge internally to suggest appropriate variants

---

## Role Naming Pattern

**Discovered Pattern:** `{Experience} {Focus/Variant} {Responsibility}`

```
{Experience} {Focus/Variant} {Responsibility}
    │              │              │
    │              │              └── Base role: Developer, Writer, Reviewer, Architect, Analyst, Tester
    │              │
    │              └── Variant modifier: Production, Security, Policy, Solution, etc.
    │
    └── Seniority: Senior, Mid-Level
```

**Examples:**
- Senior Prototype Developer
- Mid-Level Technical Writer
- Senior Security Reviewer
- Senior Enterprise Architect
- Mid-Level Manual Tester

**This suggests 3 dimensions:**

1. **Experience** (2 options): Senior, Mid-Level
2. **Focus/Variant** (varies by base role): ~40 options total across all base roles
3. **Responsibility/Base Role** (6 that vary + ~10 singular): Developer, Writer, Reviewer, Architect, Analyst, QA + Scrum Master, Release Manager, etc.

**Possible schema representation:**

```yaml
role:
  base: developer
  variant: production
  experience: senior
```

Or flattened: `senior-production-developer`

---

## Open Questions

1. Should we support role combinations (e.g., "Senior Developer with Security focus")?
2. How do we handle roles that aren't relevant to a project type?
3. ~~Should seniority be a separate field or baked into role name?~~ **LEANING: Separate field (see naming pattern above)**
4. Are there roles we've missed that are critical for either code or documentation deliverables?
5. Is "User Advocate" the right name, or is there a better term? (User Champion? User Representative? End User?)
6. For SME roles, should we define domain-specific variants (Security SME, Legal SME, HR SME) or keep it generic?
7. How do "Perspective Roles" differ in activation from other roles? Are they always paired with another role?
8. ~~Should development phases be part of role activation?~~ **RESOLVED: No - phases are documentation only**
9. ~~How granular should phase detection be?~~ **RESOLVED: N/A - not implementing phase detection**
10. For the variant approach, how many variants is too many? At what point does specificity become overhead?
11. ~~Should variants have their own Senior/Mid-Level distinction?~~ **LEANING: Yes - experience is a separate dimension**
12. How do we handle cross-variant work? (e.g., writing tests while prototyping - TDD approach)

---

## Summary: What We Have

**25 Base Roles** in 6 categories:
- Creation (5): Developer, Architect, Technical Writer, UX Designer, DBA
- Validation (6): QA Engineer, Security Analyst, Performance Engineer, Auditor, SME, User Advocate
- Governance (4): Scrum Master, Release Manager, Compliance Officer, Legal Counsel
- Strategy (6): Product Owner, Business Analyst, Financial Analyst, CEO, CTO, Project Manager
- Operations (4): DevOps Engineer, Support Engineer, Change Manager, Risk Manager

**40 Role Variants** across 6 base role families:
- Developer (8): Prototype, Production, Refactoring, Performance, Security-Focused, Test, Maintenance, API
- Writer (9): Draft, Technical, Policy, Editorial, User Guide, Executive, Compliance, Training, Maintenance
- Reviewer (8): SME, Editorial, Stakeholder, Legal, User, Code, Security, Architecture
- Architect (5): Solution, Enterprise, Security, Data, Integration
- Analyst (5): Business, Data, Security, Financial, Risk
- QA (5): Manual Tester, Automation Engineer, Performance Tester, Security Tester, Accessibility Tester

**2 Experience Tiers:** Senior, Mid-Level

**2 Lifecycle Phase Maps** (documentation only, not framework mechanism):
- Application Development (12 phases)
- Documentation/Policy (12 phases)

**Naming Pattern:** `{Experience} {Variant} {Base Role}`

---

## Proposed Role Schema

**Status:** Draft (2026-01-16)

After exploring comprehensive role definitions, we refined down to a minimal schema that balances thoroughness with simplicity.

### Design Principle: Mindset Is Enough

A well-written mindset statement can encode priorities, constraints, and typical outputs without needing separate fields for each. For example:

> "Measure first, optimize bottlenecks, don't prematurely optimize."

This single mindset contains:
- **Priority:** measurement, targeted optimization
- **Constraint:** don't prematurely optimize
- **Implied output:** performance metrics, optimized code

Separate `priorities`, `constraints`, and `typical_outputs` fields would be redundant.

### Universal Schema (5 Properties)

Every role uses the same structure:

```yaml
role_name:
  family: string       # Category: creation | validation | governance | strategy | operations
  verb: string         # Primary action this role performs
  description: string  # Human-readable summary

  tiers:               # Experience-level distinctions
    mid_level:
      mindset: string  # The internal voice at this level
    senior:
      mindset: string  # The internal voice at this level

  variants:            # Optional: specialized contexts (only for roles that vary)
    variant_name:
      mindset: string  # The internal voice for this variant
```

### Example: Developer Role

```yaml
developer:
  family: creation
  verb: builds
  description: "Implements functional software from requirements and designs"

  tiers:
    mid_level:
      mindset: "Does this work correctly and follow our standards?"
    senior:
      mindset: "Is this the right approach? What are we trading off? Will we regret this?"

  variants:
    prototype:
      mindset: "Speed over polish. Prove the concept. Don't overthink."
    production:
      mindset: "Maintainable, tested, robust. Handle errors gracefully."
    refactoring:
      mindset: "Improve structure without changing behavior. Small steps, keep tests green."
    performance:
      mindset: "Measure first. Optimize bottlenecks. Don't prematurely optimize."
    security_focused:
      mindset: "How could this be exploited? Validate inputs, sanitize outputs, least privilege."
    test:
      mindset: "What could break? Cover edge cases. Tests document intent."
    maintenance:
      mindset: "Understand before changing. Minimize blast radius. Don't break existing behavior."
    api:
      mindset: "Design for the consumer. Consistency, discoverability, backwards compatibility."
```

### Example: Singular Role (No Variants)

```yaml
scrum_master:
  family: governance
  verb: facilitates
  description: "Guides team workflow, removes impediments, and maintains process health"

  tiers:
    mid_level:
      mindset: "Is the process being followed? What's blocked?"
    senior:
      mindset: "Is this process helping? What's the team really struggling with? Are we doing agile or being agile?"

  variants: null  # This role doesn't have context-specific variants
```

### Schema Properties Explained

| Property | Required | Purpose |
|----------|----------|---------|
| `family` | Yes | Categorization for organization and filtering |
| `verb` | Yes | The core action - what this role *does* |
| `description` | Yes | Human understanding, onboarding |
| `tiers` | Yes | Senior vs Mid-Level mindset distinctions |
| `variants` | No | Specialized contexts; null for singular roles |

### What We Intentionally Excluded

| Excluded Property | Why |
|-------------------|-----|
| `domains` | Inferrable from role (Developer works with code) |
| `trigger_phrases` | Detection logic, not role identity - belongs elsewhere |
| `priorities` / `deprioritizes` | Redundant with well-written mindset |
| `constraints` | Can be folded into mindset |
| `typical_outputs` | Descriptive, not prescriptive; inferrable from context |
| `activation` | Detection logic, not role identity |

### Combining Experience + Variant

The full role identifier combines all three dimensions:

```
{experience}-{variant}-{base_role}
```

Examples:
- `senior-prototype-developer`
- `mid_level-technical-writer`
- `senior-security-reviewer`
- `senior-scrum_master` (no variant for singular roles)

### Design Decisions

**Decision: Default to Senior experience**

If experience tier is unspecified, default to Senior. We want excellence from the start. However, a validation check should flag if something seems to be missing context that a Senior would catch - this could indicate the user actually wanted Mid-Level execution without the broader judgment.

**Decision: Variant mindset overrides tier mindset**

When a variant is active, its mindset replaces (not augments) the base tier mindset. The variant is the more specific context and should dominate. Example: "Prototype Developer" uses the prototype mindset, not "Senior Developer mindset + prototype modifier."

**Decision: No role combinations (for now)**

"Developer with Security focus" is just Security-Focused Developer, not a combination of two roles. One role at a time keeps the model simple. If we find this limiting in practice, we can revisit.

---

### Critical Open Question: Activation/Detection

**Status:** Exploring - this is the make-or-break question

How does the system know which role/variant to activate?

#### Activation Mechanisms Evaluated

| Mechanism | Reliability | Friction | Implementation | Notes |
|-----------|-------------|----------|----------------|-------|
| **Explicit selection** | High | High | Easy | User says "act as X" or uses command |
| **Trigger phrase matching** | Medium | Low | Medium | "Just get it working" → Prototype Developer |
| **Context inference** | Low-Medium | None | Hard | Infer from file type, task, etc. |
| **Project configuration** | High | Medium (once) | Easy | Defined in framework.yaml |
| **Hybrid** | High | Low | Hard | Layers multiple mechanisms |

**Key insight:** Reliability is essential. A confident wrong answer is worse than asking.

#### Proposed Approach: Layered Configuration

Rather than a single default, use layered configuration with explicit selection as primary.

**Layer 1: Project Config (framework.yaml)** - Which roles are *available/relevant*

```yaml
ai:
  roles:
    enabled:
      - developer
      - security_analyst
      - architect
      - technical_writer
    disabled:
      - financial_analyst    # not relevant for this project
```

This filters the list, doesn't prescribe what to use.

**Layer 2: User Config (external to repo)** - Personal defaults

**Layer 3: Explicit Selection** - This specific task

Precedence: explicit > user config > project config > ask

#### User Configuration: Scalability Consideration

**Constraint:** Solution should be immediately scalable with no collision risk, even if not optimal.

**Options evaluated:**

| Approach | Collision Risk | Scales? | Survives Clone? |
|----------|----------------|---------|-----------------|
| `config-<username>.yaml` in repo | Username collision possible | No | Yes |
| `.user/` directory in repo (gitignored) | Low | Yes | No |
| `~/.spearit/preferences.yaml` (home dir) | None | Yes | Yes |
| Environment variables | None | Yes | Yes (with shell config) |

**Potential Solution: Home Directory with Project Reference**

```
~/.spearit/projects.yaml
```

```yaml
# ~/.spearit/projects.yaml
projects:
  project-framework:          # matches project.id in framework.yaml
    default_role: senior-production-developer
    default_experience: senior

  client-webapp:
    default_role: senior-security-focused-developer
```

**Why this approach:**

- Zero collision risk - each user has their own home directory
- Keyed by `project.id` from framework.yaml (already exists)
- Single file manages preferences across all projects
- Survives fresh clones
- Team members never touch each other's config
- Config lives outside repo, which is arguably correct - user preferences *are* external to project

**Tradeoff:** Config doesn't travel with repo. User must set up on each machine.

---

### Activation Strategy: Explicit Commands First

**Decision:** Start with explicit slash commands for reliable activation. Add smarter detection later.

#### Why Explicit First

| Approach | Reliability | Ships When |
|----------|-------------|------------|
| Explicit commands | High | Now |
| AI suggestions ("Want me to switch?") | Medium | Later |
| Context inference | Low-Medium | Future (supplemental only) |

Explicit commands are reliable, testable, and teach users the role system exists.

#### Command Prefix: `/fw-`

**Decision:** All framework commands use `/fw-` prefix to avoid collisions.

**Rationale:**
- Avoids collision with Claude Code builtins (`/init`, `/status`, `/help` are taken)
- Avoids collision with other plugins/MCP servers
- Self-teaching: typing `/fw-` shows all framework commands via autocomplete
- Short enough (3 chars) to not be burdensome
- Clear namespace for framework functionality

#### Proposed Role Commands

| Command | Purpose |
|---------|---------|
| `/fw-role` | Show current role; with argument, switch role (e.g., `/fw-role security-analyst`) |
| `/fw-roles` | List all available roles for this project |
| `/fw-setup` | Initialize framework, introduce roles, set defaults |

#### Full Command Set (Integrates with FEAT-018)

| Command | Purpose | Category |
|---------|---------|----------|
| `/fw-setup` | Initialize framework, introduce roles, set user defaults | Setup |
| `/fw-role` | Show/switch AI role | Role |
| `/fw-roles` | List available roles for this project | Role |
| `/fw-status` | Project status summary | Information |
| `/fw-backlog` | Review and prioritize backlog (FEAT-017) | Workflow |
| `/fw-wip` | Check WIP limits and current work | Workflow |
| `/fw-release` | Prepare release | Workflow |
| `/fw-validate` | Check framework compliance | Utility |

#### Role Switching UX

```
User: /fw-role security-analyst

AI: Switched to Senior Security Analyst.

   Mindset: "How would I attack this? What assumptions are we
   making about trust? Should this feature exist given the
   security cost?"

   I'll focus on threat modeling, vulnerability identification,
   and attack surface analysis.
```

User sees exactly what changed and why.

#### Setup Flow (at `/fw-setup`)

```
Project type: application
Available roles for this project:
  • Developer (prototype, production, refactoring, maintenance, ...)
  • Architect (solution, security, data, ...)
  • Security Analyst
  • QA Engineer
  • Technical Writer

You can switch roles anytime with "/fw-role <name>".

Set a default role? [Senior Production Developer]
```

Introduces roles without being verbose. User learns the system while configuring.

#### Phased Rollout

| Phase | What Ships | Activation Method |
|-------|------------|-------------------|
| **1** | `/fw-role`, `/fw-roles`, `/fw-setup` | Explicit commands only |
| **2** | AI suggestions | "This looks like security work - switch to Security Analyst?" |
| **3** | Context hints | Supplemental inference, never overrides explicit |

Start simple, gather usage data, add intelligence incrementally.

---

### Remaining Open Questions

1. **No role + no default:** Ask user, or fall back to generic assistant?
2. **Project type → default base role:** Should project type suggest a starting role?
3. **Trigger phrases:** Worth adding as Phase 2 supplement, or skip to AI suggestions?

---

### Related Work Items

- **[FEAT-018: Claude Command Framework](../work/todo/feature-018-claude-command-framework.md)** - Establishes the `/fw-` command infrastructure. Role commands (`/fw-role`, `/fw-roles`, `/fw-setup`) should be implemented within this framework.

- **[FEAT-017: Backlog Review Command](../work/todo/feature-017-backlog-review-command.md)** - First command using the framework. Will become `/fw-backlog` under the new naming convention.

**Implementation note:** FEAT-059 role activation depends on FEAT-018 command framework being in place. Consider implementing FEAT-018 first, then adding role commands as part of FEAT-059.

---

**Last Updated:** 2026-01-16
