# RooFlow Scripts

This directory contains PowerShell scripts to help you apply RooFlow custom modes to your projects.

## Available Scripts

### 1. `apply-to-existing-project.ps1`

This script automates the process of applying RooFlow custom modes to an existing project.

#### Usage

```powershell
.\apply-to-existing-project.ps1 -ProjectPath "C:\path\to\your\project"
```

#### Parameters

- `-ProjectPath` (Required): The full path to your existing project directory

#### What it does

1. Creates a `.roomodes` file with a Test mode configuration
2. Creates a `.rooignore` file with common patterns to ignore
3. Creates a `memory-bank` directory with the following files:
   - `productContext.md`
   - `activeContext.md`
   - `systemPatterns.md`
   - `decisionLog.md`
   - `progress.md`

### 2. `setup-new-project.ps1`

This script automates the process of creating a new project with RooFlow custom modes.

#### Usage

```powershell
.\setup-new-project.ps1 -ProjectName "YourProjectName" -ProjectPath "C:\path\to\parent\directory"
```

#### Parameters

- `-ProjectName` (Required): The name of your new project
- `-ProjectPath` (Optional): The parent directory where the project will be created (defaults to current directory)

#### What it does

1. Creates a new project directory with the specified name
2. Initializes a Git repository
3. Creates a `.roomodes` file with a Test mode configuration
4. Creates a `.rooignore` file with common patterns to ignore
5. Creates a `.gitignore` file with common patterns to ignore
6. Creates a `memory-bank` directory with the following files:
   - `productContext.md`
   - `activeContext.md`
   - `systemPatterns.md`
   - `decisionLog.md`
   - `progress.md`
7. Creates a basic `README.md` file
8. Creates a basic project structure with `src`, `docs`, and `tests` directories

## Prerequisites

- PowerShell 5.1 or later
- Git installed and available in your PATH

## Examples

### Apply to an existing project

```powershell
.\apply-to-existing-project.ps1 -ProjectPath "C:\Users\Emily\Projects\my-existing-project"
```

### Create a new project

```powershell
# Create in the current directory
.\setup-new-project.ps1 -ProjectName "my-new-project"

# Create in a specific directory
.\setup-new-project.ps1 -ProjectName "my-new-project" -ProjectPath "C:\Users\Emily\Projects"
```

## Next Steps After Running Scripts

1. Open the project in VS Code
2. Start a new Roo Code task in Architect mode
3. Roo will detect the memory bank and activate it
4. Begin with a project planning session
5. Use the "Update Memory Bank" or "UMB" command at key milestones

## Troubleshooting

If you encounter any issues:

1. Make sure you have the necessary permissions to create files and directories
2. Check that Git is installed and available in your PATH
3. Verify that the paths you provide exist and are accessible