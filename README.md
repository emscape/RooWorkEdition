# RooFlow: Comprehensive Development Workflow Toolkit

RooFlow is an integrated toolkit that enhances your development workflow with custom Roo modes, memory management, documentation tools, and Atlassian integration. This package provides everything you need to streamline your development process, improve documentation, and enhance collaboration.

## Key Features

- **Custom Roo Modes**: Extend Roo with specialized modes tailored to your project needs
- **Memory Bank System**: Persistent memory for Roo to maintain context across sessions
- **ADF Documentation Workflow**: Convert Markdown to Atlassian Document Format (ADF) for seamless integration with Confluence and Jira
- **MCP Server Integration**: Connect to Managed Code Platform servers for extended functionality
- **Project Setup Automation**: Quickly set up new projects or enhance existing ones

## Getting Started

### For New Projects

1. **Copy the Package**: Copy the `roo_package` directory to your computer
2. **Run the Unpack Script**:
   ```powershell
   path\to\roo_package\scripts\unpack.ps1
   ```
   
   To specify a custom project name:
   ```powershell
   path\to\roo_package\scripts\unpack.ps1 -ProjectName "CustomProjectName"
   ```

3. **Using Roo**: If you're using Roo, you can simply tell it in Code mode:
   ```
   Roo, unpack yourself
   ```
   Roo will automatically handle the unpacking process for you.

### For Existing Projects

1. **Copy the Package**: Copy the `roo_package` directory to your project
2. **Run the Apply Script**:
   ```powershell
   .\scripts\apply-to-existing-project.ps1
   ```

## Components

### 1. ADF Documentation Toolkit

The Atlassian Document Format (ADF) toolkit provides tools for working with ADF, the JSON-based format used by Atlassian products.

#### Tools Included:

- **adf-viewer.html**: Browser-based viewer for ADF documents
- **markdown-to-adf.html**: Browser-based converter from Markdown to ADF
- **markdown-to-adf.js**: Command-line Node.js script for converting Markdown to ADF
- **adf-documentation.json**: Comprehensive documentation on ADF format
- **example-adf.json**: Simple example of an ADF document

#### Using the ADF Workflow:

1. Write documentation in Markdown format in the `docs` directory
2. Run the conversion script to generate ADF files:
   ```powershell
   .\convert-docs.ps1
   ```
3. View the ADF files using the ADF Viewer:
   ```
   .\tools\adf\adf-viewer.html
   ```
4. Upload to Confluence (if desired):
   ```powershell
   .\confluence-uploader.ps1
   ```

### 2. Memory Bank System

The Memory Bank system provides persistent memory for Roo, allowing it to maintain context across sessions.

#### Key Files:

- **productContext.md**: Project overview, goals, features, and architecture
- **activeContext.md**: Current focus, recent changes, and open questions
- **systemPatterns.md**: Design patterns, architectural patterns, and coding standards
- **decisionLog.md**: Record of important decisions
- **progress.md**: Progress tracking

#### Using the Memory Bank:

1. The Memory Bank is automatically initialized during setup
2. Roo will detect and activate the Memory Bank when you start a new task
3. Use the "Update Memory Bank" or "UMB" command at key milestones
4. Archives are automatically maintained in the `memory-bank/archives` directory

### 3. MCP Server Integration

RooFlow includes integration with Managed Code Platform (MCP) servers, particularly the Confluence MCP server.

#### Confluence MCP Server Features:

- Convert Markdown to ADF
- Upload content to Confluence
- Retrieve Confluence pages
- Search Confluence content

#### Setting Up the Confluence MCP Server:

1. Navigate to the server directory:
   ```bash
   cd mcp/adf-confluence-server
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Configure environment variables:
   ```bash
   cp .env.template .env
   ```
   Edit the `.env` file with your Confluence details

4. Build and run the server:
   ```bash
   npm run build
   npm start
   ```

5. Configure Roo to use the server:
   ```powershell
   .\scripts\Configure-McpServers.ps1
   ```

### 4. Custom Roo Modes

RooFlow includes custom Roo modes that extend Roo's capabilities for specific tasks.

#### Managing Custom Modes:

- Custom modes are defined in the `.roomodes` file
- To synchronize modes across repositories:
  ```powershell
  .\scripts\sync-roomodes.ps1
  ```

## Scripts Reference

### Setup Scripts

- **unpack.ps1**: Unpacks the RooFlow package and runs the setup script
- **setup-new-project.ps1**: Initializes a new project with RooFlow features
- **apply-to-existing-project.ps1**: Adds RooFlow features to an existing project

### ADF Workflow Scripts

- **setup-adf-workflow.ps1**: Sets up the ADF documentation workflow
- **demo-adf-workflow.ps1**: Demonstrates the ADF workflow
- **convert-docs.ps1**: Converts Markdown files to ADF format
- **confluence-uploader.ps1**: Uploads ADF content to Confluence

### Configuration Scripts

- **Configure-McpServers.ps1**: Configures MCP servers
- **sync-roomodes.ps1**: Synchronizes custom modes across repositories
- **Initialize-RooMemorySystem.ps1**: Initializes or resets the Memory Bank system

## Directory Structure

```
project-root/
├── .roo/                  # Roo configuration
├── .roomodes              # Custom modes definition
├── .rooignore             # Files to ignore in Roo
├── docs/                  # Documentation
│   └── adf/               # ADF-formatted documentation
├── memory-bank/           # Memory Bank files
│   └── archives/          # Memory Bank archives
├── memory-archives/       # Additional memory archives
├── mcp/                   # MCP servers
│   └── adf-confluence-server/ # Confluence MCP server
├── scripts/               # Setup and utility scripts
└── tools/                 # Tools and utilities
    └── adf/               # ADF tools
```

## Troubleshooting

### Script Execution Issues

If you encounter issues running PowerShell scripts:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Node.js Requirements

The ADF conversion tools require Node.js. If you encounter errors:

1. Ensure Node.js is installed
2. Check that the `node` command is available in your PATH
3. Try running the conversion manually:
   ```
   node ./tools/adf/markdown-to-adf.js input.md output.json
   ```

### MCP Server Connection Issues

If you have trouble connecting to MCP servers:

1. Check that the server is running
2. Verify your environment variables and configuration
3. Check the server logs for errors

## Resources

- [Atlassian Document Format Documentation](https://developer.atlassian.com/cloud/jira/platform/apis/document/structure/)
- [Atlassian Editor](https://atlaskit.atlassian.com/packages/editor/editor-core)
- [Node.js](https://nodejs.org/)