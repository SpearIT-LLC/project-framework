# Gary's Thoughts
2026-07-16

## Abstract
Time for some serious soul searching about what we've built. 

My thoughts about the current state of the Framework. This doc is in preparation for a retrospective. Overall I've been happy with the SpearIT Framework but it feels like we still have some structural or architectual problems that's holding it back. 

The big tell is the cascade of issues we've had recently. Fixing one issue, exposes another issue which exposes yet another issue. It's an onion, and I hate onions. 

## What Is the Framework?
Take a fresh view of what the SpearIT Framework is and why we created it. 
Pull past discussions about the Framework from history and note the core issues and philosophies.


Identify the core features of the Framework and the principles that drive it. 
## Features
- File based Kanban
  - Issue Types 
  - Obsidian check lists 
- Role based activity 
- Project or Repo Type 
  - Application 
  - Documentation / Knowledge Base
  - Customer (multiple streams)
  - Toolbox 
  - Library 
  - Operations
  NOTE: Multiple streams might be the best idea here. Perhaps this should be the default concept. Each stream could be its own Type. 
- Dogfood it’s development 
- Slash Commands 
  - Swarm
  - Roadmaps
- Session History (extremely valuable)
- Project guidance (never fully implemented)
- Developer guidance (never fully implemented)

## Guiding Principles
- No code without a plan or No implementation without a plan 
- DRY documentation/Single source of Truth 
- The Framework aides contractors 
- Documentation ships with code, not after. or Documentation and Code are one deliverable.
- What are we missing? Do we need to wordsmith any of the current principles? add new?

## Problems
- Documentation duplication (in-spite of our DRY guideline)
- Balancing deterministic and AI processes
- Review history for major issues
- Too many dependencies

## Other
Go through the session history and pull out the discussions we've had about the Framework. What it is, what it does, who it helps, why it was created, it's organic history, problems and challenges. 

What does the Framework truly do well today?
What does it fail at?
Does it try to do too much?
Is there room for it to do more?
How would Anthropic approach this problem?
What is the simplest way to achieve our goals?
Are we ready for a completely fresh version of the framework? Do we treat what we have as a very informative working prototype or incrementally patch what we have?

What other questions or topics am I missing?

## Structure Thoughts
- Is our structure scalable?
- Does it work for all ProjectTypes?
- Keep project-hub or split?
session history and the Kanban flow seem to make sense. 
The question becomes how much else make sense in an extended customer engagement with multiple streams? 
What works for all ProjectTypes?


### Streams
- Move all work into "stream" folders?
- I'm not super crazy about the "stream" name. Perhaps we can come up with something else later.
  - Alt name ideas: 
    - engagements/
    - tracks/
    - workspaces/
    - initiatives/
    - programs/
    - work/ (collides with Kanban work)
    - deliverables/
    - activities/
    - portfolio/
    - domains/
    - practice-areas/
    - work-items/
    - areas/
    - jobs/
    - work-streams/
- Should all streams have a common root or all be anchored to repo root?
- Each stream could have a different sub-folder structure depending on it's type?
  So in this strategy, the stream gets the project type and not the whole project and the repo becomes more flexible. 
- How does the framework fit this model?

streams (or whatever we call it)
  stream1
  stream2
  stream3

  stream_common (all streams get these)
    research
    meetings
    planning
  stream_application/library (this is really the same from a project perspective)
    poc
    src
    tests
    distrib or releases? 
  stream_operations
    requests? (or create a request work item, or just use TASK)
  stream_kb
    (see SpearIT-KB project ref)
    C:\Users\gelliott\OneDrive\Documents\SpearIT\Projects\SpearIT-KB
  stream_toolkit (what would be different than application or library?)
  stream_sow (activity related to a specific SOW for a customer)
    An SOW stream could be a combo of a few things. e.g. One SOW could multiple deliverables that are directly related (like features in an app) or not.
    An SOW stream is the new animal in the zoo.

- Consider new command:
	/fw-add-stream <name> <type> <description>
	Prompt name, type and description if not supplied. (or maybe just name and type)
	AI does a mini swarm to understand the purpose and context, then creates the full folder structure for the named stream with a README.
	Do a mini swarm or just ask a few clarifying questions so AI knows what kind of template you need. 
	A mini swarm has the advantage of being scalable if we get something new down the road.
	Create a template for each stream type.





### Alt Ideas for discussion:
Flatten project-hub because it's generic for activity?
kanban
  backlog
  todo
  doing
  done
  archive (or cancelled)
  ~~released (here or in the stream? Con: might be hard to find if we bury in the streams.)~~
    ~~stream1 (alt idea)~~
    ~~stream2~~
    ~~stream3~~
  (Keep released in the stream folders)
history (session history)
  sessions
    YYYY (is it worth grouping by year? It might be helpful in lengthy engagements.)
      YYYY-MM-DD SESSION HISTORY.md (or drop YYYY)

#### Questions
Where do retrospectives go? (keep project wide or stream focused?)
What is generic repo wide, what should be stream only?
What should we leave alone?


## Claude Commands
Review all current and potential future commands.


## Outside Ideas
Are there other projects like "Superpowers" we can learn from?
Anthropic philosophies


## 2026-07-23
Plugin driven architecture exploration.

### AI Collaboration Objectives (CLAUDE.md and related?)
SpearIT Framework Contract
- /fw-init 
  - Adds framework contract, leaves user edits.
  - calls fw-init.sh <-- Reads framework-contract.txt 
  - Output CLAUDE.md with SpearIT Framework Contract inserted up top
- /fw-new-workspace <keyword?>  or pick a different name from (#Streams).
  - Create the project scaffolding
  - Alternate names
    - fw-new-stream (or whatever we call it)
  - Keywords
    - application stream (application, library or toolkit)
    - knowledgebase stream
    - sow stream
    - operations stream
    - 

### Workflow (File-based Kanban)
A simple file-based Kanban. 
Mostly deterministic scripts with some AI assistance. 
Embed the rules within each command?
- /fw-new <type> <title>
  - Creates a new work item based work-item-types.txt and templates. 
  - Does it require a .sh script?
  - AI assists with filling in the detail. This is what adds the value.
  - Obsidian check lists.
- /fw-move <item-id> <target-folder> [--force]
  /fw-move "<id1>, <id2>" <target-folder> [--force]
  - calls fw-move.sh.  This is mostly a deterministic action.
  - hook gates items in done? (or is this actually linked to commit?)
- /fw-kanban-state 
  - Show a summary of current project state
- /fw-next-id 
  - Returns the next available work item ID from the common namespace.
  - calls fw-next-id.sh
- The location is the status.
- Build the Kanban scaffolding on first use or separate command?
- Embed the workflow rules in fw-move.sh? fw-move.sh becomes the SoT for the workflow. The only potential draw back to that I see is finding the info to provide help guidance for the user. 
  Another idea might be to list the valid transitions in a text formatted file (txt, csv, yaml) that both fw-move.sh and AI help read direct. (similar to work-item-types.txt)
- Kanban folder structure

### Planning/Retrospective
- Forward or backward looking
- /fw-swarm
  - AI facilitated planning.
  - Ask for output folder in a multi-stream env.
- /fw-roadmap
  - AI facilitated project planning
  - Ask for output folder in a multi-stream env.
- /fw-research 
  - Is this planning or work?
  - AI research and summary on a given topic
  - Ask for output folder in a multi-stream env.
- Daily Todo list
  - Some means to prioritize the daily or maybe weekly tasks. 
  - Or maybe simplify to top 10 next most important tasks.

### Work
- Human and AI role based collaboration relative to the task at hand.
- Application activity flows through time tested development cycle.
- KnowlegeBase captures how to scenarios and procedures for both human and AI.
- Operations activity manages requests, fulfilment, reporting. 
- SOW activity cover building the SOW and tracking the progress. The work might be a combiniation of other activity.
- /fw-swarm
  - AI facilitated problem solving for current issues to assist with the activity above.
- What built-in or third-party pluggin commands might help?

### Release/Publish
- /fw-release [product-id]
  - How to make our work available to downstream users (customers, departments, ourselves).
  - May require some thought how to implement for multiple streams.
  - Use Semantic Versioning (https://semver.org)

### Journaling
- /fw-session-history
  - Capture the journey of what we did and why. 
  - One file per day.
  - Save to history/sessions/YYYY/YYYY-MM-DD SESSION HISTORY.md
  - Build scaffolding on first use?

### VSCode permissions issue
Could this help with all the prompts in VSCode?
Bash permissions in settings.json not enforced - requires custom hook workaround
https://github.com/anthropics/claude-code/issues/18846
