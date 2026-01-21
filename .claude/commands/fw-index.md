# /fw-index - Framework Topic Index

Display the source-of-truth index for framework topics. Answers "where is X documented?"

## Usage

```
/fw-index [filter]
```

## Arguments

- `filter` (optional): Filter topics by pattern (supports wildcards like `workflow*`)

## Behavior

1. Read `framework.yaml` sources section (the source of truth)
2. Parse and flatten nested topic entries
3. Display formatted table (script outputs flat; Claude adds categories for presentation)
4. If filter provided, show only matching topics

## Output Format (Default)

The script outputs a flat table sorted alphabetically:

```
Framework Topic Index (31 topics)

Topic                      Source
-----                      ------
adr-process                docs/collaboration/workflow-guide.md#architecture-decision-records-adrs
ai-checkpoint-policy       CLAUDE.md#ai-workflow-checkpoint-policy-critical---adr-001
ai-reading-protocol        CLAUDE.md#ai-reading-protocol
ai-roles                   docs/ref/framework-roles.yaml
...

Filter: -Filter <pattern> (e.g., 'workflow', 'ai', 'security')
```

When presenting in the session window, Claude may organize topics into logical categories for readability.

## Output Format (JSON)

```json
{
  "workflow-process": "framework/docs/collaboration/workflow-guide.md#development-workflow-phases",
  "code-quality": "framework/docs/collaboration/code-quality-standards.md",
  ...
}
```

## Data Sources

- **Source of Truth**: `framework.yaml` (sources section)
- **Schema**: `framework/docs/ref/framework-schema.yaml`

## Examples

```
/fw-index                    # Full topic index
/fw-index workflow*          # All workflow-related topics
/fw-index security           # Just the security topic
/fw-index pattern*           # All pattern topics
```

## Implementation

```powershell
# Default (full table)
.\framework\tools\Get-FrameworkIndex.ps1

# Filtered
.\framework\tools\Get-FrameworkIndex.ps1 -Filter "workflow*"

# JSON output
.\framework\tools\Get-FrameworkIndex.ps1 -Format json

# Just list topic names
.\framework\tools\Get-FrameworkIndex.ps1 -ListTopics
```

## Use Cases

1. **"Where is workflow documented?"** - Run `/fw-index workflow*`
2. **"What's the source of truth for security?"** - Run `/fw-index security`
3. **"List all topics"** - Run `/fw-index` for full index
4. **Machine parsing** - Use `-Format json` for tooling integration

## Edge Cases

- **framework.yaml missing**: Error with suggestion to specify path
- **No sources section**: Warning, exit gracefully
- **No matches for filter**: "No topics found matching 'X'"
- **powershell-yaml not installed**: Attempt auto-install, or show install instructions

## Related

- `framework.yaml` - Source of truth for topic index
- `/fw-help` - General framework command help
- `framework/docs/ref/framework-schema.yaml` - Schema for framework.yaml
