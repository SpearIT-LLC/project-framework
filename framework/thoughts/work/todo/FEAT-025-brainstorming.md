# SpearIT Project Brainstorming Ideas

**ID:** FEAT-025.1
**Type:** Feature
**Priority:** Medium
**Version Impact:** None
**Created:** 2026-01-01

---

## Summary

Brainstorming document for FEAT-025 manual setup validation strategy.

---

## Abstract
This doc is for brainstorming a strategy for feat-025.

Our project template project has matured considerably since inception but has mostly focused on framework workflow issues. 
We are at the point in the project where we need to focus more directly on the core problem we're trying to solve. Perhaps we should have developed an MVP sooner, however, the previous activity has helped bring clarity to the overall problem space.
viz. An easy to use project framework that manages workflow, so that a developer can focus on solutions for their project. 

The work done to date is not wasted but may have to be reorganized with feat-025.

There are A LOT of discussion points and questions in this document and will have to be sorted out and split into many workitems.


## Review Overall Project Goals
Compare these with current documented goals:
- Review existing project goals. Revise, clarify and adjust where needed.
- Establish an easy to use, yet thorough framework for one or more projects of various size and complexity. 
- The template should be able to be downloaded/copied and unzipped anywhere the user wants.
- Must be very easy to get started with a project with only very simple instructions. The framework should guide from there.
- Hopefully, the framework is simple enough for a novice but nuanced and complete enough for a veteran.
- Users first experience must be quick and positive.
- AI must know where to find all documentation quickly and never loose context.
- Humans must have an easy to follow guide that starts at a high level and drills down to the details as needed.
- The framework must make efficient use of AI tokens. (this should be a topic for future, in depth, discussion)
- The framework can use other available AI features if beneficial and make it more efficient.
- Even though my initial vision for this framework was internal to SpearIT, I MIGHT make this framework available for general public use. Either way, it should work well with an audience with minimal orientation. 
	- A public use template will have to provide clear licensing and branding guides.
	- Are there any security concerns to be aware of?
	- If made public, it would a marketing tool to show expertise more than a money making tool.
- Identify the realistic target audience.
	- I'm thinking solo and small teams is the sweet spot. Anything larger might require different tools, like Jira, for example. 
	  Perhaps integration with external tools would be a topic for an enterprise solution if we get there (feat-010).
	- Are there any particular kinds of projects this framework is realistically better or worse suited for?
- Guidance should be intuitive to find.
- The framework is built with Claude Code extension for VSCode but would be great if it easily adapted to other popular models (possible future consideration)


## Feature Discussion Questions
- feat-025 is starting to feel more like a retrospective than a feature. Should we do a retrospective first?
- Should one of the project setup questions be, what is the MVP for this project? This would help prevent the very issue we're experiencing now.
	- We should also define our MVP.
- Project guidance should take precedence over framework. 
	- How to enforce? 
	- How to catch non-conformity issues?
	- How to essentially setup first in/first out documentation and standards?
- Design for one or more projects. This gives the user a choice for scalability.
- Each user will have a different style and mix between how much manual vs AI activity going on in the project. 
	- How can AI help enforce the framework even for manual activity?
- Project configuration questions:
	- How to save releases?
		- Save work items only?
		- Save archived copies of all files so the entire release is self contained in it's current state.
- Should the framework or project have a master config file using json or yaml (or something else other than markdown)?
	- Would a config file be more efficient for AI?
	- Would we loose important nuance in a config file compared to md?
	- Would a config file be too difficult to modify? (not from a technical perspective but from a process or workflow perspective)
	- How does both human and AI know what each config setting really mean?
- How will this template work for multiple projects if each project has it's own git repo?
- What do we do if user wants to modify the core framework?
	- If we have framework config, this might give them some basic configurability.
	- What are the things someone might want to change? (covering the major items is too big for feat-025 but MIGHT be worth consideration once the template is more mature)
- Define the pros an cons of our file/folder based Kanban system. This may be the limiting factor for our target audience.
- Project setup. Should it offer to initialize a git repo?
- Is CLAUDE-QUICK-REFERENCE.md still useful?
- What is the logical learning path for a human to learn the framework?
- What is the logical learning path for AI to learn the framework?
- How do we blend our framework project documentation with our new structure?
	- Treat the framework like it's own project but in the framework folder? i.e. It's project name IS framework?
	- The framework project is a standard project.
	- User projects reference the framework project?
	- So framework project contains everything a standard project has?
	


## High Level Structure Ideas
### All in one Concept
spearit-project-framework/
├── CLAUDE.md			# A README for AI
├── README.md			# A README for humans
├── LICENSE   			# Framework license
├── QUICK-REFERENCE.md  # How to get started quickly
├── framework/			# Independent framework (universal for all projects)
│   ├── INDEX.md		# 
│   ├── CHANGELOG.md		# 
│   ├── STRUCTURE.md		# 
│   ├── thoughts/		# Do we remove the thoughts/ folder in framework? (Makes folders one layer flatter)
│	├── process/		# How-to-work (workflow, standards, etc.) Project independent guidance.
│	├── tools/			# or scripts to aid framework processes
│	└── templates/		# All framework templates
│		├── project/	# Zip archives of each project type. Get's unzipped to projects/ folder at setup.
│		│	├── light/
│		│	├── minimal/
│		│	└── standard/
│		└── workitems/
│		
│	 
├── project-light/			# Each project gets a "proj" or "project" preface. Keeps project folders at the same level as the framework.
├── project-hello-sample/	# Framework comes with a sample hello world project (Perhaps we provide 2? One complete, one for a tutorial)
└── project-standard/		# Default one project but able to add others by reinitiating project setup.
	├── src/				# Project source code and deliverables.
	├── docs/				# Project documentation
	├── templates/			# Project templates
	├── project-specific/	# Future placeholder for project folder
	└── thoughts/
		├── history
		│	├── releases/
		│	├── spikes/
		│	└── sessions/
		├── work/
		│	├── backlog/		# Move here or leave in planning? (I'm not crazy about the current path - thoughts/project/planning/backlog/)
		│	│	├── sprint001/	# Optional sprint planning folder(s)? (maybe future?)
		│	│	└── sprint002/	
		│	├── todo/
		│	├── doing/
		│	└── done/
		├── reference/
		├── research/
		├── retrospectives/
		└── collaboration/			# AI Collaboration



## TODO 
- Update STRUCTURE.md 



## Reference from STRUCTURE.md
standard/
├── README.md                           # Complete project README
├── CLAUDE.md                           # Full project-specific guide
├── PROJECT-STATUS.md                   # Detailed status tracking
├── CHANGELOG.md                        # Keep a Changelog format
├── INDEX.md                            # Documentation navigation
├── .gitignore                          # Comprehensive gitignore
│
└── thoughts/
    ├── framework/                      # Reusable framework (shared across projects)
    │   ├── FRAMEWORK-CHANGELOG.md      # Framework evolution tracking
    │   │
    │   ├── process/                    # How-to-work documentation
    │   │   ├── documentation-standards.md
    │   │   ├── kanban-workflow.md
    │   │   └── version-control-workflow.md
    │   │
    │   ├── templates/                  # Document and code templates
    │   │   ├── ADMIN-QUICK-START-TEMPLATE.md
    │   │   ├── ADR-MAJOR-TEMPLATE.md
    │   │   ├── ADR-MINOR-TEMPLATE.md
    │   │   ├── BLOCKER-TEMPLATE.md
    │   │   ├── BUGFIX-TEMPLATE.md
    │   │   ├── CHANGELOG-TEMPLATE.md
    │   │   ├── CLAUDE-TEMPLATE.md
    │   │   ├── FEASIBILITY-TEMPLATE.md             # Research phase
    │   │   ├── FEATURE-TEMPLATE.md
    │   │   ├── INDEX-TEMPLATE.md
    │   │   ├── LANDSCAPE-ANALYSIS-TEMPLATE.md      # Research phase
    │   │   ├── PROBLEM-STATEMENT-TEMPLATE.md       # Research phase
    │   │   ├── PROJECT-DEFINITION-TEMPLATE.md      # Research phase
    │   │   ├── PROJECT-JUSTIFICATION-TEMPLATE.md   # Research phase
    │   │   ├── PROJECT-STATUS-TEMPLATE.md
    │   │   ├── PROJECT-TEMPLATE.md
    │   │   ├── README-TEMPLATE.md
    │   │   ├── SPIKE-TEMPLATE.md
    │   │   ├── USER-QUICK-START-TEMPLATE.md
    │   │   │
    │   │   └── wrappers/               # Code templates
    │   │       └── cmd/                # PowerShell wrappers
    │   │           ├── README.md
    │   │           ├── WRAPPER.cmd
    │   │           ├── WRAPPER-ENHANCED.cmd
    │   │           ├── WRAPPER-PS7.cmd
    │   │           └── WRAPPER-ADMIN.cmd
    │   │
    │   ├── patterns/                   # Implementation patterns
    │   │   ├── cmd-wrappers.md
    │   │   ├── config-management.md
    │   │   └── powershell-modules.md
    │   │
    │   └── tools/                      # Framework tooling (empty placeholder)
    │       └── .gitkeep
    │
    └── project/                        # Project-specific content
        ├── archive/                    # Historical/outdated docs
        │   └── .gitkeep
        │
        ├── history/                    # Daily session history
        │   ├── .gitkeep
        │   ├── releases/               # Release-specific docs
        │   │   └── .gitkeep
        │   └── spikes/                 # Spike/experiment results
        │       └── .gitkeep
        │
        ├── planning/                   # Project planning
        │   ├── backlog/                # Planned features
        │   │   └── .gitkeep
        │   └── roadmap-template.md     # Roadmap template
        │
        ├── reference/                  # Current project docs
        │   └── .gitkeep
        │
        ├── research/                   # Project research
        │   ├── adr/                    # Architecture Decision Records
        │   │   └── .gitkeep
        │   └── .gitkeep
        │
        ├── retrospectives/             # Project retrospectives
        │   └── .gitkeep
        │
        └── work/                       # Kanban workflow
            ├── todo/                   # Planned work
            │   ├── .gitkeep
            │   └── .limit              # WIP limit (default: 10)
            ├── doing/                  # In progress
            │   ├── .gitkeep
            │   └── .limit              # WIP limit (default: 1)
            └── done/                   # Completed work
                └── .gitkeep



