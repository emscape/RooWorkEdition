# ADF Integration Documentation

## Introduction

### Overview

This document describes the integration of the ADF (Atlassian Document Format) workflow and memory system into the RooFlow project setup scripts. The integration consolidates functionality from multiple scripts into the main setup scripts, making it easier to set up new projects and apply the configuration to existing projects.

### Learning Objectives/Expected Outcomes
* Understand how the ADF workflow is integrated into the project setup scripts
* Learn how the memory system is incorporated into the project initialization process
* Identify the key integration points between different components
* Be able to use the ADF conversion functionality to convert Markdown to ADF format
* Know how to view and upload ADF files to Confluence

## Table of Contents
- [Introduction](#introduction)
- [Integration Components](#integration-components)
- [Key Integration Points](#key-integration-points)
- [Using the ADF Conversion Functionality](#using-the-adf-conversion-functionality)
- [Testing the Integration](#testing-the-integration)
- [Conclusion](#conclusion)

## Integration Components

The integration combines functionality from three scripts:

1. **`Initialize-RooMemorySystem.ps1`**: Creates memory system directories and configuration files
2. **`setup-adf-workflow.ps1`**: Sets up ADF documentation workflow
3. **`Configure-McpServers.ps1`**: Configures MCP servers (kept as a separate script)

These components have been integrated into:

- **`setup-new-project.ps1`**: For creating new projects
- **`apply-to-existing-project.ps1`**: For applying the configuration to existing projects

## Key Integration Points

### Memory System Integration

- Creates memory-bank, memory-bank/archives, memory-archives, and .roo directories
- Creates memory-config.json with appropriate default settings
- Creates empty archive files and archive-index.md
- Creates mcp-config.json in the `.roo` directory (standardized location)

### ADF Workflow Integration

- Creates docs/adf and tools/adf directories
- Copies ADF tools from the repository root
- Creates docs/adf/README.md, convert-docs.ps1, and sample documentation
- Updates .gitignore for ADF directories

### MCP Configuration Handling

- Creates a default mcp-config.json in the `.roo` directory
- Includes instructions to run `Configure-McpServers.ps1` manually
- The `Configure-McpServers.ps1` script looks for the config file in `.roo/mcp-config.json`

## Using the ADF Conversion Functionality

The ADF conversion functionality allows you to convert Markdown files to Atlassian Document Format (ADF), which can be used with Atlassian products like Confluence.

### Prerequisites

- Node.js installed and available in the system's PATH

### Converting Markdown to ADF

1. Create or edit Markdown files in the `docs` directory
2. Run the conversion script:
   ```powershell
   .\convert-docs.ps1
   ```
3. The converted ADF files will be created in the `docs/adf` directory

### Viewing ADF Files

1. Open the ADF viewer in a web browser:
   ```powershell
   Start-Process ".\tools\adf\adf-viewer.html"
   ```
2. Click "Load from File" and select an ADF JSON file from the `docs/adf` directory

### Uploading to Confluence

If you have configured the Confluence MCP server:

1. Configure the MCP server:
   ```powershell
   .\scripts\Configure-McpServers.ps1
   ```
2. Set up the Confluence credentials in the `.env` file
3. Use the Confluence MCP server to upload the ADF content to Confluence

## Testing the Integration

The integration has been tested by:

1. Creating a convert-docs.ps1 script
2. Setting up the tools/adf directory with the necessary ADF tools
3. Creating the docs/adf directory
4. Successfully converting all Markdown files in the docs directory to ADF format

## Conclusion

The integration of the ADF workflow and memory system into the RooFlow project setup scripts has been completed successfully. The functionality is now available in a more streamlined and user-friendly way, making it easier to set up new projects and apply the configuration to existing projects.