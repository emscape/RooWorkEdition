# Apply RooFlow Custom Modes to Existing Project
# This script automates the process of applying RooFlow custom modes to an existing project
# Usage: .\apply-to-existing-project.ps1 -ProjectPath "C:\path\to\your\project"

param(
    [Parameter(Mandatory=$true)]
    [string]$ProjectPath
)

# Verify the project path exists
if (-not (Test-Path -Path $ProjectPath -PathType Container)) {
    Write-Error "The specified project path does not exist: $ProjectPath"
    exit 1
}

# Navigate to the project directory
Push-Location $ProjectPath

try {
    Write-Host "Applying RooFlow custom modes to project at: $ProjectPath" -ForegroundColor Green

    # Step 1: Create .roomodes file if it doesn't exist
    if (-not (Test-Path -Path ".roomodes")) {
        Write-Host "Creating .roomodes file..." -ForegroundColor Yellow
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
        Write-Host "Created .roomodes file" -ForegroundColor Green
    } else {
        Write-Host ".roomodes file already exists" -ForegroundColor Yellow
    }

    # Step 2: Create .rooignore file if it doesn't exist
    if (-not (Test-Path -Path ".rooignore")) {
        Write-Host "Creating .rooignore file..." -ForegroundColor Yellow
        $rooignoreContent = @'
node_modules/
dist/
build/
.git/
*.log
'@
        Set-Content -Path ".rooignore" -Value $rooignoreContent
        Write-Host "Created .rooignore file" -ForegroundColor Green
    } else {
        Write-Host ".rooignore file already exists" -ForegroundColor Yellow
    }

    # Step 3: Create memory-bank directory if it doesn't exist
    if (-not (Test-Path -Path "memory-bank")) {
        Write-Host "Creating memory-bank directory..." -ForegroundColor Yellow
        New-Item -Path "memory-bank" -ItemType Directory | Out-Null
        Write-Host "Created memory-bank directory" -ForegroundColor Green
    } else {
        Write-Host "memory-bank directory already exists" -ForegroundColor Yellow
    }

    # Get current timestamp
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    # Get project name from directory
    $projectName = Split-Path -Path $ProjectPath -Leaf

    # Step 4: Create memory bank files if they don't exist
    $memoryBankFiles = @{
        "productContext.md" = @"
# Product Context

## Project Overview
[Brief description of $projectName]

## Goals
- [Goal 1]
- [Goal 2]

## Features
- [Feature 1]
- [Feature 2]

## Architecture
[High-level architecture description]
"@
        "activeContext.md" = @"
# Active Context

## Current Focus
[Current focus of development]

## Recent Changes
RooFlow memory bank initialized on $timestamp

## Open Questions/Issues
[Open questions or issues]
"@
        "systemPatterns.md" = @"
# System Patterns

## Design Patterns
[Design patterns used in the project]

## Architectural Patterns
[Architectural patterns used in the project]

## Coding Standards
[Coding standards followed in the project]
"@
        "decisionLog.md" = @"
# Decision Log

[$timestamp] - RooFlow memory bank initialized
"@
        "progress.md" = @"
# Progress

[$timestamp] - RooFlow memory bank initialized
"@
    }

    foreach ($file in $memoryBankFiles.Keys) {
        $filePath = "memory-bank/$file"
        if (-not (Test-Path -Path $filePath)) {
            Write-Host "Creating $filePath..." -ForegroundColor Yellow
            Set-Content -Path $filePath -Value $memoryBankFiles[$file]
            Write-Host "Created $filePath" -ForegroundColor Green
        } else {
            Write-Host "$filePath already exists" -ForegroundColor Yellow
        }
    }

    Write-Host "`nRooFlow custom modes have been successfully applied to the project!" -ForegroundColor Green
    Write-Host "`nNext steps:" -ForegroundColor Cyan
    Write-Host "1. Open the project in VS Code" -ForegroundColor Cyan
    Write-Host "2. Start a new Roo Code task in Architect mode" -ForegroundColor Cyan
    Write-Host "3. Roo will detect the memory bank and activate it" -ForegroundColor Cyan
    Write-Host "4. Begin with a project planning session to populate the memory bank" -ForegroundColor Cyan
    Write-Host "5. Use 'Update Memory Bank' or 'UMB' command at key milestones" -ForegroundColor Cyan

} catch {
    Write-Error "An error occurred: $_"
} finally {
    # Return to the original directory
    Pop-Location
}