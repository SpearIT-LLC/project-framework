# Follow up questions after FEAT-026 Reorg

## Abstract
These are my thoughts, questions and observations after the reorganization. Some of my observations might have existed before the reorg and some happened during the reorg. This is simply my observations on where we're at now.

## Random Observations
- We agreed to make copies of the files but you used git mv. We made this decision for safety. As far as I know everything went OK, but we took a risk doing that and it was a violation of our agreement. In the spirit of dogfooding, we should discuss why this happened and how to prevent in the future.Did moving the files around affect your ability to read the agreement? 
- Does a work/hold/ folder make sense for a workitem that is not complete but then a very urgent item comes through and needs to supercede it? Not an item we need resolve now but worth discussing in the future.
- I'm seeing a lot of repitition in the documentation and sometimes it contradicts itself.
- All the docs need to be double checked for invalid file references.
- Perhaps the INDEX.md should define which file is the single source of truth for any topic? This is open for discussion.
- Double check the current project files with the established project template.

## Items for Discussion 
**\README.md**
- line 3. Does a reference to framework/PROJECT-STATUS.md make sense here?
- line 17. We're calling the folder, project-framework-template/ but that name could be confusing but it's really just project-templates/.
- lines 12, 19. Let's remove the enterprise reference everywhere, until or if we ever actually build an enterprise framework.
- line 23. So we have a quick start guide in the readme and a quick start doc? I think we made a decision to make a clear separation between these two.
- line 66. What's included. We don't have different framework levels. The framework is singular and fixed. Each project type will use various levels of detail from it. However, those details have not been established. We have a Framework, Project Templates and a Sample Project.
- Folder paths need to be updated throughout.
- line 193. Should we reference a specific version here and risk it not be up-to-date? Also, I'm not sure it's really projection ready. When I think of production ready, I'm thinking we can give it to someone new or outside the company and they can use with no issues. We're getting close but not quite there.
- line 218 - Examples. Are those Setup Times realistic or just made up? I'd rather have nothing than a made up number. Perhaps a better attribute would be to describe how much of the framework you'll use with each. But again, we haven't implemented these yet, so really we only have a conceptual model.
- line 240 - Perhaps we can find a way to add other projects to this list.
- line 272. Another version reference that's already outdated. Maybe we just say "Planned".
- line 308. We need workitem to discuss which license we'll use.

**project-framework\framework\CLAUDE.md**
- line 28 references the "Standard Framework Level" but we've never defined what that is. In a new session, will this be clear for AI?
- line 32, The architecture folders look out of date. Should we be defining any of this here?
- Critical folder paths are wrong.
- The 11 Steps - Step 2. Why mention a time frame for research? It doesn't make sense to artifically rush this step. Maybe we just all it "Research". Let it take whatever time it needs without being overly verbose.
- Step 7. Just a thought, are we adding a redundant step by updating the status within the file when it's already sitting in a status folder?
- Step 9. We may want to revisit this step to refine it. I think we agreed on one workitem per release. Should the framework allow a user the option to release multiple items at the same time under the same version number? e.g. bugfix-001, bugfix-002 and bugfix-003?
- line 240 Example Interaction. Perhaps we should change line 256 to something like "Should I move to todo/?" or maybe not prompt any action. Let the rest of the workflow work as designed. If we prompt to implement, we're violating our own workflow.
- Is the workflow too detailed in CLAUDE.md? Is there too much duplication from the workflow-guide.md?
- line 300 - The Three Dimensions. We created this when we had 3 distinct project types, light, minimal and standard. For now, we've narrowed our scope to standard, so we don't actually have a light and minimal project type yet. So the question is, do we leave this alone or move it into a new feature for when we add the other project types?
- line 309 - This framework, at least as it is now, would realistically never be used with a large team. Maybe we remove any large team or enterprise references until or even if we grow this project that far.
- line 424 - Documentation. It might be worth it to add something to state a core documentation principle - Use DRY principles with documentation. Every policy should have a single source of truth. Some duplication can be ok for reference but always include links to the source.
- Also, there is no \CLAUDE.md at the repo root like we agreed to.


**CLAUDE-QUICK-REFERENCE.md**
- All file paths need review and update
- line 17. We reference The 9 Steps, but CLAUDE references 11. This is another case of duplication. Let's make a note to clean this up.
- line 129. I think this is repeated info.

**framework/**
- Where is the docs/ folder?
- Does this structure match our project structure standard? It seems it doesn't.


**project-hello-world/**
- I see you created a .js script. We probably want to use some more straight forward like Powershell. Don't change it now. We'll address the details of this sample project with another feature update.

