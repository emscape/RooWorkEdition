# Confluence Uploader Setup Guide

## Introduction

### Overview
This document provides comprehensive instructions for setting up and using the Confluence uploader to automatically publish your documentation to Confluence. The guide covers two implementation approaches: a standalone PowerShell script and an MCP server integration. By following this guide, you'll be able to establish an efficient documentation-as-code workflow that seamlessly integrates with Atlassian Confluence.

### Learning Objectives/Expected Outcomes
* Understand the two approaches for Confluence integration (PowerShell script vs. MCP server)
* Learn how to configure and use the confluence-uploader.ps1 script
* Set up and configure the Confluence MCP server
* Implement an automated documentation workflow for Confluence publishing
* Troubleshoot common issues with the Confluence uploader

## Table of Contents
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Approach 1: Using the PowerShell Script](#approach-1-using-the-powershell-script)
- [Approach 2: Using the MCP Server](#approach-2-using-the-mcp-server)
- [Workflow Integration](#workflow-integration)
- [Troubleshooting](#troubleshooting)
- [Next Steps](#next-steps)

## Prerequisites

Before you begin, you'll need:

* An Atlassian Confluence account with API access
* Your Atlassian account email
* An API token (generate one at https://id.atlassian.com/manage-profile/security/api-tokens)
* Your Confluence space key
* Node.js installed (for both approaches)

## Approach 1: Using the PowerShell Script

The `confluence-uploader.ps1` script provides a simple way to convert Markdown files to ADF format and upload them to Confluence.

### Setup

1. **Configure the script** (optional):
   
   Open `confluence-uploader.ps1` and update the default parameters if desired:

   ```powershell
   [string]$confluenceUrl = "https://your-domain.atlassian.net",
   [string]$email = "your-email@example.com",
   [string]$apiToken = "your-api-token",
   [string]$spaceKey = "SPACE",
   ```

2. **Ensure the tools directory exists**:

   The script expects the markdown-to-adf.js tool to be in the `./tools/adf/` directory. If it's not there, run the `convert-docs.ps1` script first, which will create the necessary directories and copy the tools.

### Usage

#### Converting and Uploading a Single File

1. Run the script:

   ```powershell
   .\confluence-uploader.ps1
   ```

2. When prompted, enter:
   - Your Confluence URL (if not pre-configured)
   - Your Atlassian account email
   - Your API token
   - Your Confluence space key
   - Optional parent page ID (if you want to create the page as a child of another page)
   - Path to the Markdown file you want to upload
   - Title for the Confluence page

#### Uploading All ADF Files

1. First, convert all your Markdown files to ADF format:

   ```powershell
   .\convert-docs.ps1
   ```

2. Then run the uploader with the `-uploadAll` switch:

   ```powershell
   .\confluence-uploader.ps1 -uploadAll
   ```

3. When prompted, enter your Confluence credentials.

## Approach 2: Using the MCP Server

The MCP (Model Context Protocol) server provides a more integrated approach, allowing Roo to directly interact with Confluence.

### Installation

1. Navigate to the MCP server directory:

   ```powershell
   cd mcp/adf-confluence-server
   ```

2. Run the installation script:

   ```powershell
   .\install.ps1
   ```

   This will:
   - Check if Node.js is installed
   - Install npm dependencies
   - Build the TypeScript code
   - Create a .env file from the template

3. Configure the .env file:

   Open the `.env` file in the `mcp/adf-confluence-server` directory and fill in your Confluence details:

   ```
   CONFLUENCE_BASE_URL=https://your-domain.atlassian.net
   CONFLUENCE_USERNAME=your-email@example.com
   CONFLUENCE_API_TOKEN=your-api-token
   CONFLUENCE_SPACE_KEY=SPACE
   ```

4. Start the server:

   ```powershell
   npm start
   ```

### Configuration in Roo

1. Run the Configure-McpServers.ps1 script:

   ```powershell
   .\scripts\Configure-McpServers.ps1
   ```

2. When prompted about the Confluence server:
   - Select "y" to enable it
   - Choose which tools to allow (convertMarkdownToAdf, uploadToConfluence, getConfluencePage, searchConfluence)

3. The script will check if the required environment variables are set in your .env file.

### Usage with Roo

Once configured, Roo can use the following MCP tools:

1. **convertMarkdownToAdf**: Convert Markdown content to ADF format
2. **uploadToConfluence**: Upload content to Confluence as a new page
3. **getConfluencePage**: Retrieve a Confluence page by ID
4. **searchConfluence**: Search for content in Confluence

## Workflow Integration

For the best documentation workflow:

1. Write your documentation in Markdown format in the `docs/` directory
2. Run `convert-docs.ps1` to convert all Markdown files to ADF format
3. Use either the PowerShell script or MCP server to upload the documentation to Confluence

### Automated Workflow

You can automate this process by:

1. Adding the conversion and upload steps to your CI/CD pipeline
2. Creating a scheduled task to run the scripts periodically
3. Using Git hooks to trigger the conversion and upload when documentation is updated

## Troubleshooting

### Common Issues

1. **Authentication Errors**:
   - Ensure your API token is correct and not expired
   - Check that your email address matches your Atlassian account

2. **Conversion Errors**:
   - Make sure Node.js is installed and accessible
   - Check that the markdown-to-adf.js tool is in the correct location

3. **Upload Errors**:
   - Verify your Confluence space key is correct
   - Ensure you have permission to create pages in the specified space

### Getting Help

If you encounter issues:

1. Check the console output for error messages
2. Review the Confluence API documentation
3. Ensure all prerequisites are met

## Next Steps

- Create a documentation template for consistency
- Set up a documentation review process
- Implement version control for your documentation