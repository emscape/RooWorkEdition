# Applying RooFlow Custom Modes to Future Projects

This guide explains how to set up new projects with RooFlow custom modes and memory bank functionality from the beginning.

## Step 1: Project Setup with Memory Bank

When starting a new project, follow these steps to incorporate RooFlow's memory bank functionality:

1. Create your new project directory:

```powershell
mkdir your-new-project
cd your-new-project
```

2. Initialize your version control system (if using Git):

```powershell
git init
```

3. Create a `.roomodes` file in the project root:

```powershell
New-Item -Path ".roomodes" -ItemType File
```

4. Add the following content to the `.roomodes` file:

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

5. Create a `.rooignore` file to exclude unnecessary files from Roo's context:

```powershell
New-Item -Path ".rooignore" -ItemType File
```

6. Add common patterns to ignore:

```
node_modules/
dist/
build/
.git/
*.log
```

## Step 2: Initialize Memory Bank Structure

1. Create the memory bank directory and required files:

```powershell
mkdir memory-bank
New-Item -Path "memory-bank/productContext.md" -ItemType File
New-Item -Path "memory-bank/activeContext.md" -ItemType File
New-Item -Path "memory-bank/systemPatterns.md" -ItemType File
New-Item -Path "memory-bank/decisionLog.md" -ItemType File
New-Item -Path "memory-bank/progress.md" -ItemType File
```

2. Initialize the memory bank files with project-specific content:

### productContext.md Template
```markdown
# Product Context

## Project Overview
[Brief description of your new project]

## Goals
- [Primary goal]
- [Secondary goal]

## Features
- [Core feature 1]
- [Core feature 2]

## Architecture
[Initial architecture decisions]
```

### activeContext.md Template
```markdown
# Active Context

## Current Focus
Initial project setup and planning

## Recent Changes
Project initialization

## Open Questions/Issues
- [Initial question/issue 1]
- [Initial question/issue 2]
```

### systemPatterns.md Template
```markdown
# System Patterns

## Design Patterns
[Initial design patterns]

## Architectural Patterns
[Initial architectural patterns]

## Coding Standards
[Project-specific coding standards]
```

### decisionLog.md Template
```markdown
# Decision Log

[YYYY-MM-DD HH:MM:SS] - Project initialized with RooFlow memory bank
```

### progress.md Template
```markdown
# Progress

[YYYY-MM-DD HH:MM:SS] - Project setup with RooFlow memory bank
```

## Step 3: Project Kickoff with Roo

1. Open your project in VS Code
2. Start a new Roo Code task in Architect mode:
   - Click on the Roo Code icon
   - Select "Architect" from the mode dropdown
   - Roo will detect the memory bank and activate it

3. Begin with a project planning session:
   - Define the project scope
   - Outline the architecture
   - Plan initial development tasks

4. Use the "Update Memory Bank" or "UMB" command at key milestones to ensure all context is saved

## Step 4: Development Workflow

1. Use different Roo modes based on your current task:
   - Architect mode for planning and design
   - Code mode for implementation
   - Debug mode for troubleshooting
   - Ask mode for questions and information
   - Test mode for testing strategies

2. Regularly update the memory bank to maintain project context

3. For collaborative projects, ensure all team members have access to the memory bank files (e.g., through version control)

## Template Script

You can use this PowerShell script to quickly set up a new project with RooFlow memory bank:

```powershell
# RooFlow Project Setup Script
param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectName
)

# Create project directory
New-Item -Path $ProjectName -ItemType Directory
Set-Location $ProjectName

# Initialize Git
git init

# Create .roomodes file
$roomodesContent = @'
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
'@
Set-Content -Path ".roomodes" -Value $roomodesContent

# Create .rooignore file
$rooignoreContent = @'
node_modules/
dist/
build/
.git/
*.log
'@
Set-Content -Path ".rooignore" -Value $rooignoreContent

# Create memory bank directory and files
New-Item -Path "memory-bank" -ItemType Directory

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

# Create productContext.md
$productContextContent = @"
# Product Context

## Project Overview
[Brief description of $ProjectName]

## Goals
- [Primary goal]
- [Secondary goal]

## Features
- [Core feature 1]
- [Core feature 2]

## Architecture
[Initial architecture decisions]
"@
Set-Content -Path "memory-bank/productContext.md" -Value $productContextContent

# Create activeContext.md
$activeContextContent = @"
# Active Context

## Current Focus
Initial project setup and planning

## Recent Changes
Project initialization

## Open Questions/Issues
- [Initial question/issue 1]
- [Initial question/issue 2]
"@
Set-Content -Path "memory-bank/activeContext.md" -Value $activeContextContent

# Create systemPatterns.md
$systemPatternsContent = @"
# System Patterns

## Design Patterns
[Initial design patterns]

## Architectural Patterns
[Initial architectural patterns]

## Coding Standards
[Project-specific coding standards]
"@
Set-Content -Path "memory-bank/systemPatterns.md" -Value $systemPatternsContent

# Create decisionLog.md
$decisionLogContent = @"
# Decision Log

[$timestamp] - Project initialized with RooFlow memory bank
"@
Set-Content -Path "memory-bank/decisionLog.md" -Value $decisionLogContent

# Create progress.md
$progressContent = @"
# Progress

[$timestamp] - Project setup with RooFlow memory bank
"@
Set-Content -Path "memory-bank/progress.md" -Value $progressContent

Write-Host "RooFlow project '$ProjectName' has been set up successfully!"
Write-Host "Open the project in VS Code and start using Roo with memory bank functionality."
```

Save this script as `setup-rooflow-project.ps1` and run it with:

```powershell
.\setup-rooflow-project.ps1 -ProjectName "your-new-project"