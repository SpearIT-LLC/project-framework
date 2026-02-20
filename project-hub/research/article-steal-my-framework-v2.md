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
While building my own commands and a plugin equivilent, I stumbled on a major Claude bug that could be disastrous in the right circumstances. I have a project level command that I converted to a plugin command. They currently both exist but do the same thing. I called the plugin version but Claude decided to run the local command even though they have different namespaces. It turns out Claude decides on the fly whether to respect the namespace. The namespaces are not a guaranteed path like they are in your code. Now suppose I install some random plugin that happens to have the same or similar name. I call one command, but Claude thinks the other is close enough and runs it instead. I can only imagine the mess that could create. I filed a bug, [#26906](https://github.com/anthropics/claude-code/issues/26906), hopefully it's resolved quickly.

## The Rebellious Child
You know the one. Maybe you have one. You ask them to do one thing a specific way and they make up their own mind how or if it should be done at all. AI can be tempermental in it's own way. The fact is AI does not always like to be told how. We've setup policies together, gave an instruction related to the policy and it did it it's own way anyway. I'd follow up with what is our policy for 'X', and it would spit out the policy verbatim followed up with an "oops", I didn't do that.

<paragraph on solutions and workarounds>

Hooks can help but don't solve everything.

## History
Version 1 was what we established in the initial application. Version 2 was when we moved it to it's own project. Version 3 was a major reorg when the light bulb hit, the framework IS a project and is now structured the same as a "user" project.



---

## Executive Summary

The SpearIT Framework is an AI collaboration partner for consultants and solo developers. It gives Claude the structure it needs to work like a professional colleague — not a forgetful assistant you have to re-brief every session.

The core problem: every Claude session starts cold. Decisions made last Tuesday, the approach you rejected, the policy you spent an hour refining — gone. Without structure, you spend the first 20 minutes of every session re-establishing context. With a large enough project, you never fully recover it.

The framework solves this with three things:

**A shared memory system.** Session history captures not just what changed, but why — the reasoning, the dead ends, the decisions. Git remembers what the files look like. Session history remembers how you got there. Future sessions — and future AI — pick up where you left off.

**A collaboration contract.** Work items, policies, workflow transitions, and role definitions written in plain markdown that both you and Claude read and follow. When Claude knows the rules of the project, it stops improvising and starts collaborating.

**Consistent execution.** Scripts for repeatable operations, slash commands for common workflows, hooks to enforce policy. The same action produces the same result whether you run it or Claude does.

The framework is file-based, lives in your repo, and requires no external tools or subscriptions. It scales from a solo consultant working with a single client to a small team managing multiple projects.

It started as a tool I built for myself. A way to bring professional discipline to AI-assisted consulting work. I'm sharing it because the problem it solves isn't unique to me.

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
