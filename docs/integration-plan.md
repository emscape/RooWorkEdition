# Integration Plan: Setup Scripts Consolidation

## Introduction

### Overview
This document outlines a comprehensive plan for consolidating multiple setup scripts into a more streamlined workflow. The integration focuses on combining the functionality of `Configure-McpServers.ps1`, `Initialize-RooMemorySystem.ps1`, and `setup-adf-workflow.ps1` into the existing `setup-new-project.ps1` and `apply-to-existing-project.ps1` scripts. This consolidation will simplify the project setup process and ensure consistent configuration across new and existing projects.

### Learning Objectives/Expected Outcomes
* Understand how the various setup scripts will be integrated into a unified workflow
* Learn about the standardization of configuration file locations
* Identify potential conflicts and their resolutions in the integration process
* Gain insight into the sequence of operations for the consolidated setup process
* Be able to implement the integration plan with clear steps and considerations

## Table of Contents
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Analyzed Scripts](#analyzed-scripts)
- [Key Observations & Conflicts](#key-observations--conflicts)
- [Proposed Integration Plan](#proposed-integration-plan)
- [Visual Plan](#visual-plan-mermaid-sequence-diagram)

## Prerequisites
* Familiarity with PowerShell scripting
* Access to all the scripts mentioned in the integration plan
* Understanding of the RooFlow project structure and configuration
* Knowledge of MCP servers, memory system, and ADF workflow concepts

## Analyzed Scripts

1.  **`scripts/setup-new-project.ps1`**: Creates a new project with basic Git, Roo config, memory bank, README, and folder structure.
2.  **`scripts/apply-to-existing-project.ps1`**: Adds Roo config and memory bank structure to an existing project.
3.  **`scripts/Configure-McpServers.ps1`**: Interactively configures MCP servers based on `.roo/mcp-config.json` and checks `.env`.
4.  **`scripts/Initialize-RooMemorySystem.ps1`**: Creates memory system directories (`memory-bank/archives`, `memory-archives`, `.roo`) and files (`memory-config.json`, root `mcp-config.json`, archive files).
5.  **`scripts/setup-adf-workflow.ps1`**: Creates ADF directories (`docs/adf`, `tools/adf`), copies ADF tools from the repo root to `tools/adf`, creates ADF README, a conversion script (`convert-docs.ps1`), a sample doc, and updates `.gitignore`.

## Key Observations & Conflicts

*   **Interactivity:** `Configure-McpServers.ps1` requires user interaction.
*   **`mcp-config.json` Location:** `Initialize-RooMemorySystem.ps1` creates it at the project root, while `Configure-McpServers.ps1` expects it in `.roo/`. This will be standardized to `.roo/mcp-config.json`.
*   **ADF Tool Source:** `setup-adf-workflow.ps1` copies tools assuming they are in the *current* directory. This needs adjustment to copy from the repository root when integrated.
*   **Dependencies:** The ADF workflow relies on Node.js for conversion.

## Proposed Integration Plan

1.  **Standardize `mcp-config.json` Location:**
    *   Consistently use `.roo/mcp-config.json` as the standard location.
    *   Modify the logic from `Initialize-RooMemorySystem.ps1` to place the created `mcp-config.json` inside the `.roo` directory.

2.  **Integrate `Initialize-RooMemorySystem.ps1` Logic:**
    *   **Into `setup-new-project.ps1`:** Add steps to create the `.roo` directory, `memory-bank/archives`, `memory-archives`, `memory-bank/memory-config.json`, the empty archive files within `memory-bank/archives`, `memory-bank/archives/archive-index.md`, and the default `.roo/mcp-config.json`.
    *   **Into `apply-to-existing-project.ps1`:** Add the same steps, but include checks (`Test-Path`) to ensure directories and files are only created if they don't already exist.

3.  **Integrate `scripts/setup-adf-workflow.ps1` Logic:**
    *   **Into `setup-new-project.ps1`:**
        *   Add steps to create `docs/adf` and `tools/adf` directories.
        *   Modify the tool copying logic: Determine the path to the repository root relative to the script's location (`$PSScriptRoot`) and copy the necessary ADF tool files (`adf-viewer.html`, `markdown-to-adf.html`, etc.) from the repo root into the project's `tools/adf` directory.
        *   Add steps to create `docs/adf/README.md`, `convert-docs.ps1` (at the project root), and the sample `docs/getting-started.md` if no other `.md` files exist in `docs`.
        *   Add logic to update the project's `.gitignore` file.
    *   **Into `apply-to-existing-project.ps1`:** Add the same steps, but include `Test-Path` checks for all directories and files being created. The `.gitignore` update should also check if the lines already exist before adding them.

4.  **Handle `Configure-McpServers.ps1` (MCP Configuration):**
    *   **Decision:** Keep the interactive configuration separate.
    *   **Action:** Both setup scripts will ensure the default `.roo/mcp-config.json` exists.
    *   **Action:** Add a clear message to the final output of both setup scripts, instructing the user to run the configuration script manually if needed, providing the command: `.\scripts\Configure-McpServers.ps1`.
    *   **(Optional but Recommended):** Modify `scripts/Configure-McpServers.ps1` separately to explicitly look for the config file at `.roo/mcp-config.json`.

5.  **Add Dependency Notes:**
    *   Include a note in the final output of both setup scripts mentioning that the ADF workflow's `convert-docs.ps1` script requires Node.js to be installed and available in the system's PATH.

## Visual Plan (Mermaid Sequence Diagram)

```mermaid
sequenceDiagram
    participant User
    participant SetupScript as setup-new-project.ps1 /<br>apply-to-existing-project.ps1
    participant InitMemSys as Initialize-RooMemorySystem Logic
    participant SetupADF as setup-adf-workflow Logic
    participant ConfigMCP as Configure-McpServers.ps1

    User->>SetupScript: Run script (with ProjectPath/Name)
    SetupScript->>SetupScript: Perform initial setup (dirs, git, .roomodes, .rooignore, basic memory-bank)
    SetupScript->>InitMemSys: Integrate Memory System Init
    InitMemSys->>InitMemSys: Create .roo, memory-bank/archives, memory-archives
    InitMemSys->>InitMemSys: Create memory-config.json, archive files, archive-index.md
    InitMemSys->>InitMemSys: Create default .roo/mcp-config.json
    SetupScript->>SetupADF: Integrate ADF Workflow Setup
    SetupADF->>SetupADF: Create docs/adf, tools/adf
    SetupADF->>SetupADF: Copy ADF tools (from repo root) to tools/adf
    SetupADF->>SetupADF: Create docs/adf/README.md, convert-docs.ps1, sample doc
    SetupADF->>SetupADF: Update .gitignore
    SetupScript->>User: Display success message
    SetupScript->>User: Instruct user to run Configure-McpServers.ps1 manually (provide command)
    SetupScript->>User: Mention Node.js dependency for ADF conversion

    Note right of User: User runs ConfigMCP separately if needed
    User->>ConfigMCP: Run Configure-McpServers.ps1
    ConfigMCP->>ConfigMCP: Read .roo/mcp-config.json
    ConfigMCP->>User: Prompt for server enablement/tools
    User->>ConfigMCP: Provide input
    ConfigMCP->>ConfigMCP: Update .roo/mcp-config.json
    ConfigMCP->>ConfigMCP: Check .env variables
    ConfigMCP->>User: Display results/warnings