# SpearIT AI Project Framework

Thoughts and ideas for an article about how I created the framework. The article would probably be published on Medium but also maybe other places.

Status: Draft


## How to create a Peanut Butter sandwich.
Have you seen the various videos where a parent or teacher asks kids to give them instructions how to create a peanut butter sandwich? Most of us have. The parent asks for instructions with no direction, the kids offer reasonable, yet vague, instructions on what to do. What the kids don't realize is how much is implied in each instruction. [How to make a Peanut Butter and Jelly Sandwich.](https://www.youtube.com/watch?v=L0vTEOl4evI) That's how I've felt working with AI. Sometimes it brilliantly picks up on the nuance of the questions or commands, other times it misses or forgets the context of the discussion altogether. This was my experience developing not an application but a robust development framework with set policies about every aspect of the workflow. What I thought would be a simple little project turned into a big project of it's own.

The idea for the project grew out of a real application that I wanted to put a formal structure around. From there, I moved the framework to it's own project with the idea of it being a reusable workflow I could use on any project from single scripts to full blown applications. That's when I really saw the peanut butter sandwich, so to speak. We've all experienced the effects of lost of context working with AI, but this just seemed to amplify the problem because now I wasn't just telling AI what to do, we were collaborating HOW to do it.

## Playing Simon-Says
We give AI a very specific command and it performs it wonderfully. Two sessions later, we give a simular instruction but without some detail or in a different context and it does it's own thing. Just like the game, Simon-Says, if we don't say "Simon-Says", we don't get the right result. This is a common complaint and there's a lot of great information out there to resolve these issues. What I wanted was to make the workflow a company standard where you could just drop the framework into your project, configure and go.

## Documentation as the Deliverable
What was unique about this project is my deliverable was the documentation, the policies, the framework that put it all together in one coherent contract for how both human and AI would agree to work together. It includes a file based Kanban workflow, templates, history, research and how to apply. Seemed simple. But AI, Claude Code in my case, would find it's own creative ways to implement the workflow. The more mature the framework became, the better things went but every few sessions there would be some nuance we forgot to define clearly. 

## Dogfood is Good
In a documentation project, is there really anything as TECH DEBT? Can you imagine the paradigm shift resisting just fixing the policies without any formal change?  I forced myself to make every change as if it were a code change. This exposed a ton of tiny issues and was critical to making this work. 

As a small company, I'm already thinking of using the framework to work on company policies and organization. In this way Claude becomes my advisory board.

## Single Source of Truth
Defining a SsoT was like herding cats because Claude can be very verbose with it's documentation. This is both good and bad. The problem is Claude has a tendency to duplicate a lot of documentation but does not always update every reference when it changes. The challenge was to first identify one source of truth for every policy and remove or greatly remove duplicate reference data. I had to apply DRY (Don't Repeat Yourself) principles to the documentation and policies themselves.

Enter framework.yaml, a simple project config file easily readable by both AI and human to direct them to the SsoT for every policy. The simple format saves tokens looking for information. Yes, CLAUDE.md can do that but this but the config file is easy to set with a script that both human and AI can run.

## Pull My Finger
CONCEPT: AI is not good at triggering policy or procdeural actions even though it is aware the policies exist. It still needs a little prompting, then it's fine.

## Role Playing
If I tell you to do something you'll probably do it however you think it should be done. But if I say you're a senior ____, then you're going to think differently about the task. Claude behaves the same way. 
(develop a realistic scenario easily understood by anyone)

## Scripts for automation tasks
This bring me to another feature, using scripts to execute standard tasks so if either human or AI executes it we get the same result. AI saves some tokens and human doesn't have to worry they'll get a different result if they run it. 

## Git is your code's memory. Session history is your AI's memory.

I use a session history command almost as often as I use git commit. That surprised me. At first I thought it was just a nice-to-have — a log of what we did today. But I kept coming back to it and started to understand why.

Git snapshots what changed in the files. Session history captures why it happened and how we got there. Every new Claude session starts cold. Without session history, you're either re-explaining context from scratch or hoping the AI figures it out from file state alone. Neither works well. Session history is the structured handoff — the thing a senior developer writes before going on vacation so the next person isn't lost on day one.

What I didn't expect was how much the act of generating it changed how I work. Knowing I'm going to document a session makes me more deliberate during it. Decisions feel more real when you have to write down the rationale. Paths you abandoned are worth noting because the next session — or the next AI — will probably consider the same dead end.

The commit captures the artifact. The session history captures the reasoning. You need both.

## I Command Thee, but only if you want to
While building my own commands and a plugin equivilent, I stumbled on a major Claude bug that could be disastrous in the right circumstances. I have a project level command that I converted to a plugin command. They currently both exist but do the same thing. I called the plugin version but Claude decided to run the local command even though they have different namespaces. It turns out Claude decides on the fly whether to respect the namespace. The namespaces are not a guaranteed path like they are in your code. Now suppose I install some random plugin that happens to have the same or similar name. I call one command, but Claude thinks the other is close enough and runs it instead. I can only imagine the mess that could create. I filed a bug, <bug-number>, hopefully it's resolved quickly.

## The Rebellious Child
You know the one. Maybe you have one. You ask them to do one thing a specific way and they make up their own mind how or if it should be done at all. AI can be tempermental in it's own way. The fact is AI does not always like to be told how. We've setup policies together, gave an instruction related to the policy and it did it it's own way anyway. I'd follow up with what is our policy for 'X', and it would spit out the policy verbatim followed up with an "oops", I didn't do that. 

<paragraph on solutions and workarounds>

Hooks can help but don't solve everything.

## History
Version 1 was what we established in the initial application. Version 2 was when we moved it to it's own project. Version 3 was a major reorg when the light bulb hit, the framework IS a project and is now structured the same as a "user" project. 



---
## Claude's Executive Summary (1st attempt)
SpearitIT Standard Project Framework
### What It Is:
A lightweight, AI-friendly project management framework that brings structure without bureaucracy - designed specifically for solo developers and small teams working with AI coding assistants.

### The Problem It Solves:
Most developers working with AI assistants face a recurring challenge: after a few sessions, context is lost. The AI forgets decisions, duplicates work, or breaks things that were working. Traditional project management is too heavy for solo work, but no structure leads to chaos.

### The Solution:
A minimal file-based system that tracks:
- Work items (features, bugs, decisions) through a simple kanban workflow
- Session history documenting what happened and why
- Architectural decisions for future reference
- Project context so AI can quickly understand the project
- Everything lives in markdown files, versioned in git. No databases, no external tools, no subscriptions.

### Key Innovation:
The framework treats documentation as infrastructure. Instead of seeing docs as overhead, it recognizes that in AI-assisted development, good documentation is what enables the AI to be productive. The framework provides just enough structure to maintain continuity across sessions without becoming a burden.

### Target Users:
- Solo developers building side projects
- Small teams (2-5 people) using AI assistants
- Anyone tired of losing context between coding sessions
- Developers who want structure without heavyweight project management tools

### Current Status:
Version 3.1.0 - Production ready for Standard-level projects. Actively dogfooded (the framework manages its own development). Open source, free to use and adapt.

### Unique Value:
Unlike traditional project management (Jira, Linear, etc.), this framework is:
- File-based - Everything in your repo, versioned with your code
- AI-native - Designed for human + AI collaboration
- Minimal - Only what you actually need
- Free - No subscriptions, no vendor lock-in
- Flexible - Three implementation levels (Minimal, Light, Standard)

### The Pitch:
"Git for project management" - simple, local, powerful, and designed for the AI age.

---
## Claude's Executive Summary (2nd attempt)
Executive Summary: Standard Project Framework
### What It Is:
A structured collaboration framework that formalizes how humans and AI work together on software projects - creating explicit contracts for workflows, decision-making, and progress tracking.

### The Core Insight:
Most people treat AI assistants like magic genies: "build me a feature" and hope for the best. This works for throwaway scripts but fails for serious projects. The AI makes assumptions, you make different assumptions, and three sessions later you're debugging chaos.

### Business projects need:
- Defined processes - Not "figure it out," but "here's how we do releases"
- Trackable progress - Not vague updates, but "3 of 7 work items completed"
- Audit trails - Not lost context, but "here's why we decided X on Tuesday"
- Repeatable workflows - Not reinventing wheels, but "follow this checklist"

### What We've Built:
A framework that codifies the collaboration contract between human and AI:

- Work item templates define what information is required (not optional guesswork)
- Kanban workflow establishes clear stages and WIP limits
- Session history creates an audit trail of decisions and progress
- Decision records document architectural choices with rationale
- CLAUDE.md files explicitly tell the AI "here's how THIS project works"

### The Difference:

- Traditional approach: "Claude, build authentication" → Claude guesses your stack, approach, and standards
- Framework approach: "Claude, implement FEAT-042 using our standard work item process" → Claude knows exactly where to create files, how to document decisions, what the release checklist requires

### Why This Matters for Business:

- Accountability - Clear work items with status tracking
- Continuity - New AI session? Read the session history and decision records
- Compliance - Documented processes and audit trails
- Reporting - "We completed 5 features, 2 bugs, made 3 architectural decisions this sprint"
- Knowledge retention - Everything documented, nothing in someone's head (or lost context)

### The Innovation:
We're not just managing a project - we're managing the collaboration itself. The framework IS the contract between human and AI about how work gets done, documented, and tracked.

### Target Users:

- Solo developers building real products (not toy projects)
- Small businesses needing professional processes without enterprise overhead
- Teams using AI who need structure and accountability
- Anyone who wants their AI assistant to work like a professional colleague, not a code-generating slot machine

### Current Status:
Version 3.1.0 - Actively dogfooded. The framework manages its own development, proving the contract works in practice.

### The Pitch:
"Stop treating AI like a magic button. Start collaborating like professionals with defined processes, clear accountability, and real visibility into progress."

---



## Features Planned
Items under discussion
- GitHub issue integration
- Jira issue integration

## Conclusion

So go ahead and download my framework. Hopefully you find it useful. I only ask you keep it together as a whole and maintain credits. 
At this time I've not opened it up for contributions but may consider for the future. I have to balance your ideas with internal workflow standards. Feel free to offer improvements or new features and I'll definitely consider them. 
[Download here](github_link)

Current version spearit_ai_framework_v3.0.1.zip
