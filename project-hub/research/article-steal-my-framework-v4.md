# Steal My Framework: How I Taught Claude to Work Like a Professional Colleague

*Target publication: Medium*

Status: Draft

**Written By Gary Elliott**
**Edited By My Buddy Claude**

---

If you use AI to do serious work — consulting, development, anything that spans multiple sessions — you've probably felt the friction. The context that doesn't carry over. The decisions that have to be re-explained. The AI that was your collaborator yesterday and a stranger today. This is the story of how I built a framework to fix that, what I learned along the way, and why I'm giving it away.

---

## How to Make a Peanut Butter Sandwich

Have you seen the various videos where a parent or teacher asks kids to give them instructions for how to create a peanut butter sandwich? Most of us have. The parent asks for instructions with no direction, the kids offer reasonable, yet vague, instructions on what to do. What the kids don't realize is how much is implied in each instruction. [How to Make a Peanut Butter and Jelly Sandwich.](https://www.youtube.com/watch?v=L0vTEOl4evI) That's how I've felt working with AI. Sometimes it brilliantly picks up on the nuance of the questions or commands, other times it misses or forgets the context of the discussion altogether. This was my experience developing not an application but a robust development framework with set policies about every aspect of the workflow. What I thought would be a simple little project turned into a big project of its own.

The idea for the project grew out of a real application that I wanted to put a formal structure around. From there, I moved the framework to its own project with the idea of it being a reusable workflow I could use on any project from single scripts to full blown applications. That's when I really saw the peanut butter sandwich, so to speak. We've all experienced the effects of lost context working with AI, but this just seemed to amplify the problem because now I wasn't just telling AI what to do, we were collaborating HOW to do it.

## Playing Simon Says

We give AI a very specific command and it performs it wonderfully. Two sessions later, we give a similar instruction but without some detail or in a different context and it does its own thing. Just like the game Simon Says, if we don't say "Simon Says," we don't get the right result. This is a common complaint and there's a lot of great information out there to resolve these issues. What I wanted was to make the workflow a company standard where you could just drop the framework into your project, configure, and go.

## The Cold Start Problem

Here's something that doesn't get talked about enough. Every time you open a new Claude session, you're talking to someone who has never met you. No memory of yesterday's decisions. No recollection that you spent three hours last week rejecting a particular approach and why. No awareness that the policy you both agreed on in session four was revised in session seven.

The framework solves the cold start with a simple ritual. At the beginning of every session, Claude reads the project configuration, checks what's in progress, and reviews the most recent session history. Five minutes of orientation that replaces twenty minutes of re-briefing. More importantly, it replaces the invisible tax of context that never fully comes back — the decisions you don't remember making, the approaches you don't remember rejecting, the reasoning you can't reconstruct from the files alone.

Think of it as the daily standup, except your team member genuinely has no memory of yesterday without it.

## Documentation as the Deliverable

What was unique about this project is that my deliverable was the documentation, the policies, the framework that put it all together in one coherent contract for how both human and AI would agree to work together. It includes a file-based Kanban workflow, templates, history, research, and how to apply. Seemed simple. But AI, Claude Code in my case, would find its own creative ways to implement the workflow. The more mature the framework became, the better things went — but every few sessions there would be some nuance we forgot to define clearly.

## Dogfood is Good

In a documentation project, is there really anything as TECH DEBT? Can you imagine the paradigm shift of resisting just fixing the policies without any formal change? I forced myself to make every change as if it were a code change. This exposed a ton of tiny issues and was critical to making this work.

As a small company, I'm already thinking of using the framework to work on company policies and organization. In this way Claude becomes my advisory board.

## Single Source of Truth

Defining a single source of truth was like herding cats because Claude can be very verbose with its documentation. This is both good and bad. The problem is Claude has a tendency to duplicate a lot of documentation but does not always update every reference when something changes. The challenge was to first identify one source of truth for every policy and remove or greatly reduce duplicate reference data. I had to apply DRY (Don't Repeat Yourself) principles to the documentation and policies themselves.

Enter `framework.yaml`, a simple project config file easily readable by both AI and human that directs them to the source of truth for every policy. The simple format saves tokens when looking for information. Yes, CLAUDE.md can do that, but the config file is easy to set with a script that both human and AI can run — and it's a single place to look instead of a long prose file.

## Pull My Finger

AI is surprisingly passive about applying its own knowledge. It will know a policy exists, recite it back to you word for word if asked, and then not apply it. You have to pull the trigger.

Here's a real example. We have a policy that every work item must have defined acceptance criteria before it moves to "in progress." Claude knows this policy. It helped write it. But move a work item and it will cheerfully complete the action without checking. Say "check our policy before moving this" and suddenly it runs the check perfectly, catches the missing criteria, and flags it.

The framework addresses this with hooks — shell commands that fire automatically at key moments — and with explicit checklist steps built into the workflow commands themselves. The goal isn't to catch Claude being wrong; it's to remove the dependency on Claude remembering to apply what it knows.

## Role Playing

If I tell you to do something, you'll probably do it however you think it should be done. But if I say you're a senior litigation attorney and ask you to write a brief, you're going to think differently about every word. Claude behaves exactly the same way.

I noticed this most clearly with the session history command. When the command prompt says "adopt a Senior Technical Writer mindset," the output is measurably different — more deliberate about capturing reasoning, more careful about documenting dead ends, more focused on what a future reader actually needs to know. The same prompt without the role assignment produces a competent but thinner result.

Roles work because they activate a different frame of reference, not just a different tone. Tell Claude it's a Senior Security Engineer reviewing your code and it will think about attack surfaces. Tell it it's a Product Manager and it will think about user impact. The role shapes what Claude notices and what it considers worth mentioning.

## Scripts for Automation Tasks

This brings me to another feature: using scripts to execute standard tasks so that if either human or AI executes them, we get the same result. AI saves some tokens and doesn't have to interpret what to do. The human doesn't have to worry they'll get a different result if they run it themselves.

There's a deeper benefit here too. When Claude has discretion over how to perform an operation, it may choose differently session to session — or choose differently than you would. A script removes that discretion entirely for deterministic operations. Moving a file, counting items, validating a format — these don't need AI interpretation. Write the script once, call it always.

## Git is Your Code's Memory. Session History is Your AI's Memory.

I use a session history command almost as often as I use git commit. That surprised me. At first I thought it was just a nice-to-have — a log of what we did today. But I kept coming back to it and started to understand why.

Git snapshots what changed in the files. Session history captures why it happened and how we got there. Every new Claude session starts cold. Without session history, you're either re-explaining context from scratch or hoping the AI figures it out from file state alone. Neither works well. Session history is the structured handoff — the thing a senior developer writes before going on vacation so the next person isn't lost on day one.

What I didn't expect was how much the act of generating it changed how I work. Knowing I'm going to document a session makes me more deliberate during it. Decisions feel more real when you have to write down the rationale. Paths you abandoned are worth noting because the next session — or the next AI — will probably consider the same dead end.

The commit captures the artifact. The session history captures the reasoning. You need both.

## I Command Thee, but Only If You Want To

While building my own commands and a plugin equivalent, I stumbled on a major Claude bug that could be disastrous in the right circumstances. I have a project-level command that I converted to a plugin command. They currently both exist but do the same thing. I called the plugin version, but Claude decided to run the local command even though they have different namespaces. It turns out Claude decides on the fly whether to respect the namespace. The namespaces are not a guaranteed path like they are in your code. Now suppose I install some random plugin that happens to have the same or similar name. I call one command, but Claude thinks the other is close enough and runs it instead. I can only imagine the mess that could create. I filed a bug, [#26906](https://github.com/anthropics/claude-code/issues/26906) — hopefully it's resolved quickly.

## The Rebellious Child

You know the one. Maybe you have one. You ask them to do one thing a specific way and they make up their own mind how or whether it should be done at all. AI can be temperamental in its own way. The fact is AI does not always like to be told how. We've set up policies together, gave an instruction related to the policy, and it did it its own way anyway. I'd follow up with "what is our policy for X?" and it would spit out the policy verbatim, followed by an "oops, I didn't do that."

Three things have helped, none of them a complete fix. First, positive framing: tell Claude what to do rather than what not to do. "Use the Glob tool directly" outperforms "don't spawn an agent." Second, hooks: enforce policy at the system level so the AI can't skip steps even when it wants to be efficient. Third, scripts: remove AI discretion entirely for deterministic operations. If the script runs it, there's no interpretation involved.

The honest punchline is that none of these fully solve it. They reduce the problem. The rebellious child grows up but never completely. What the framework gives you is a set of guardrails that make the misbehavior less frequent and less costly when it happens — and a record of what happened when it does.

## History

Version 1 was what we established in the initial application. Version 2 was when we moved it to its own project. Version 3 was a major reorg when the light bulb hit: the framework IS a project and is now structured the same as a "user" project. That turned out to matter — every improvement we made to the framework workflow immediately applied to itself.

---

## What We Built in Claude's Own Words

The SpearIT Framework is an AI collaboration partner for consultants and solo developers. It gives Claude the structure it needs to work like a professional colleague — not a forgetful assistant you have to re-brief every session.

The framework solves the problem with three things:

**A shared memory system.** Session history captures not just what changed, but why — the reasoning, the dead ends, the decisions. Git remembers what the files look like. Session history remembers how you got there. Future sessions — and future AI — pick up where you left off.

**A collaboration contract.** Work items, policies, workflow transitions, and role definitions written in plain markdown that both you and Claude read and follow. When Claude knows the rules of the project, it stops improvising and starts collaborating.

**Consistent execution.** Scripts for repeatable operations, slash commands for common workflows, hooks to enforce policy. The same action produces the same result whether you run it or Claude does.

The framework is file-based, lives in your repo, and requires no external tools or subscriptions. It scales from a solo consultant working with a single client to a small team managing multiple projects.

It started as a tool I built for myself. A way to bring professional discipline to AI-assisted consulting work. I'm sharing it because the problem it solves isn't unique to me.

---

## Features Planned

Items under discussion:
- GitHub issue integration
- Jira issue integration

## Conclusion

So go ahead and download my framework. Hopefully you find it useful. I only ask that you keep it together as a whole and maintain credits. At this time I've not opened it up for contributions but may consider it in the future. I have to balance your ideas with internal workflow standards. Feel free to offer improvements or new features and I'll definitely consider them.

### Downloads
[Plugin Light Version: Kanban Workflow Only]([github_link](https://github.com/SpearIT-LLC/project-framework/tree/main/distrib/plugin-light))
[Plugin Full Version: Light + Planning and Guidance]([github_link](https://github.com/SpearIT-LLC/project-framework/tree/main/distrib/plugin-full))
[Full Framework: Full Plugin + Performance and structural improvements]([github_link](https://github.com/SpearIT-LLC/project-framework/tree/main/distrib/framework))

Current version: spearit_framework_v5.1.0.zip
