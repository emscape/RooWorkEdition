# Applying RooFlow Custom Modes to Existing Projects

This guide explains how to apply RooFlow custom modes and memory bank functionality to your existing projects.

## Step 1: Create a Project-Specific .roomodes File

1. In the root directory of your existing project, create a `.roomodes` file:

```json
{
  "customModes": [
    {
      "slug": "test",
      "name": "Test",
      "roleDefinition": "You are Roo's Test mode for this specific project",
      "groups": [
        "read",
        "browser",
        "command",
        "edit",
        "mcp"
      ],
      "source": "project",
      "customInstructions": "Always check to make sure memory bank is active. Explicitly prompt Emily when she needs to do a manual action. terminal commands must be PowerShell. Explicitly prompt Emily when she needs to do a manual action. Save to memory and prompt user to start a new task when token cost nears $0.5"
    }
  ]
}
```

2. Customize the modes as needed for your specific project.

## Step 2: Initialize a Memory Bank

1. Create a `memory-bank` directory in your project root:

```powershell
mkdir memory-bank
```

2. Create the required memory bank files:

```powershell
New-Item -Path "memory-bank/productContext.md" -ItemType File
New-Item -Path "memory-bank/activeContext.md" -ItemType File
New-Item -Path "memory-bank/systemPatterns.md" -ItemType File
New-Item -Path "memory-bank/decisionLog.md" -ItemType File
New-Item -Path "memory-bank/progress.md" -ItemType File
```

3. Initialize each file with appropriate content:

### productContext.md
```markdown
# Product Context

## Project Overview
[Brief description of the project]

## Goals
- [Goal 1]
- [Goal 2]

## Features
- [Feature 1]
- [Feature 2]

## Architecture
[High-level architecture description]
```

### activeContext.md
```markdown
# Active Context

## Current Focus
[Current focus of development]

## Recent Changes
[Recent changes to the project]

## Open Questions/Issues
[Open questions or issues]
```

### systemPatterns.md
```markdown
# System Patterns

## Design Patterns
[Design patterns used in the project]

## Architectural Patterns
[Architectural patterns used in the project]

## Coding Standards
[Coding standards followed in the project]
```

### decisionLog.md
```markdown
# Decision Log

[YYYY-MM-DD HH:MM:SS] - Initial memory bank setup
```

### progress.md
```markdown
# Progress

[YYYY-MM-DD HH:MM:SS] - Memory bank initialized
```

## Step 3: Use the Memory Bank with Roo Code

1. Open your project in VS Code
2. Start a new Roo Code task
3. Roo will automatically detect the memory bank and activate it
4. Begin with the Architect mode to establish the project context

## Step 4: Update the Memory Bank

Use the "Update Memory Bank" or "UMB" command when you want to ensure all relevant information from your current session is saved to the memory bank.