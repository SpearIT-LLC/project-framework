# SpearIT Project Framework Notes

## Abstract
This doc is a miscellaneous list of thoughts and ideas for the framework. Some items will become official issues and others might die.


---
## DRY Documentation
Maybe check how these ideas fit with TECH-043-dry-documentation-principles.md?

### Goals
- Reduce overall documentation size.
- Remove repetition and redundancy.
- Declare one source of truth for every category.
- How to categorize all documentation? Why: Makes it easier to find and act upon.
	- Workflow
	- How to use the framework?
	- Code standards
	- Testing
	- Security
	- Templates
	- AI Collaboration
	- Reference
	- Other?
- Fix docs by category. i.e. Update and refine the docs one category at a time. This will ensure continuity across the docs.
- Reduce duplication
- Reduce overall size of documents. 
- How small can we get the docs and still keep everything clear (not cryptic) and easy to find for both human and AI. Why? Even AI only has so much memory and can loose context.
- Add glossary for human use (Quick-start.md?)
- What does a human or AI need to know?
	- or maybe a better question is HOW they need to learn it. Because both need to know the same things.
- How to 
- Reference

---
## Coding Strategy
How should human or AI approach a problem?
- MVP (just get it working)
- Establish tests
- Refactor (improve code quality and organization but same functionality)
- Optimize for security
- Optimize for performance and efficiency ()

---
## framework.yaml
issueIntegration: fileBased | GitHub | Jira 
- What's a good name for this setting?

---
## Work Items
- All work items assigned to either human or AI, should have a checklist.

---
## Integrations
Research articles for potential future solution for small groups to manage work items with Github or JIRA integration.

### TODO
- Research what is possible
- Should we do this?
- What is our MVP?
- POC scripts
- What is common between our file based issue system, GitHub and Jira?
- What is different?
- Can we keep the same workflow with each integration?


### GITHUB Issue Integration
REST API endpoints for issues
https://docs.github.com/en/rest/issues?apiVersion=2022-11-28
https://dev.to/shadbalti/ultimate-guide-build-a-complete-issue-tracker-with-the-github-api-16ak
https://rollout.com/integration-guides/github-issues/sdk/step-by-step-guide-to-building-a-github-issues-api-integration-in-js


### JIRA Integration
https://developer.atlassian.com/server/jira/platform/jira-rest-api-example-create-issue-7897248/
https://developer.atlassian.com/server/jira/platform/jira-rest-api-examples/
https://www.geeksforgeeks.org/web-tech/automating-jira-ticket-creation-using-python-and-jira-rest-api/
https://www.merge.dev/blog/how-to-get-and-create-issues-with-the-jira-api-with-code-snippets
https://www.postman.com/api-evangelist/atlassian-jira/request/fasib33/create-issue
https://www.postman.com/api-evangelist/atlassian-jira/collection/dds4ypw/jira-capability-get-issue
https://www.postman.com/api-evangelist/atlassian-jira/collection/uo6wdfu/jira-capability-search-for-jira-issues
https://www.postman.com/api-evangelist/atlassian-jira/collection/zwuz0g6/jira-capability-update-issue

---
## Why Constrain AI to Human Processes?
What are the arguements for intentionally limiting AI? 
- Limited context
- Human validation

---
## Roadmap
Define a clear roadmap. 
Perhaps document the high level map with mermaid?

- File based Kanban workflow 
- Roles
- Project templates
- Slash commands
- Code standards for popular languages?
- GitHub Workflow
- Jira Workflow
- Multi AI model support?
- Performance optimizations

---
## CLAUDE.md
- Is there anything in /CLAUDE.md that could reliably be moved to /framework/CLAUDE.md?
- Can we identify/define the minimum block of info we need to add to /CLAUDE.md to get the framework to work reliably?

## Research Claude Features
What features are we not using that might help the framework project?
- List all features with brief summary
- Which are we using?
- Which might help us?
  - SKILLS
  - MCP
  - agents
    - Split roles between agents?
  - Something else?

## Framework Project Management
- Adopt Project Manager or Product Owner role and then evaluate the project

## Project Templates
Replace project size with a template. Perhaps that might be a better, and more flexible, way to manage different kinds and sizes of projects.
- When doing the setup project configuration, recommend a project template rather than a project size.
- Develop various project templates based on the kinds of work you're doing.
- Adopt senior roles to assist with template creation
- Templates define major phases to the project? Or top level WBS?
- Template defines the purpose, scope and goals for each item 
- Does the development phase iterate for each release?

## Proof of Concept
Experiment with some of these ideas:
### Predefined checklist or questionaire
- Create series of questions in a markdown file.
- Have Claude work through the questionaire or checklist.
- Claude records the user answers.
This could be a useful pattern for other features.

#### Sample
Trivial questionaire for POC
1. What color is the sky?
2. What color is the grass?
3. What color is snow?
AI prompts each question and records the answer.

