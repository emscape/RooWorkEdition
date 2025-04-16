# ADF Integration Guide

## Introduction

### Overview
This document provides a comprehensive guide for integrating the Atlassian Document Format (ADF) workflow into your RooFlow project. ADF allows you to create rich, interactive documentation that can be seamlessly published to Confluence and other Atlassian products. This integration streamlines the documentation process by enabling you to write in Markdown and automatically convert to ADF.

### Learning Objectives/Expected Outcomes
* Understand the ADF workflow and its benefits for documentation
* Set up the ADF conversion tools in your project
* Convert existing Markdown documentation to ADF format
* View and validate ADF documents before publishing
* Upload ADF content to Confluence using the MCP server

## Table of Contents
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Step-by-Step Integration Guide](#step-by-step-integration-guide)
  - [Step One: Set Up ADF Tools](#step-one-set-up-adf-tools)
  - [Step Two: Create Conversion Script](#step-two-create-conversion-script)
  - [Step Three: Convert Documentation](#step-three-convert-documentation)
  - [Step Four: View ADF Documents](#step-four-view-adf-documents)
  - [Step Five: Configure Confluence Integration](#step-five-configure-confluence-integration-optional)
- [Troubleshooting/FAQs](#troubleshootingfaqs)
- [Additional Resources](#additional-resources)

## Prerequisites
* Node.js installed and available in the system's PATH
* Access to the RooFlow project repository
* Basic understanding of Markdown syntax
* Confluence space (if publishing to Confluence)

## Step-by-Step Integration Guide

### Step One: Set Up ADF Tools
Install and configure the necessary ADF tools in your project.

#### Sub-step 1.1: Create Required Directories
Create the directories needed for the ADF workflow:

```powershell
New-Item -ItemType Directory -Path "docs/adf" -Force
New-Item -ItemType Directory -Path "tools/adf" -Force
```

#### Sub-step 1.2: Copy ADF Tools
Copy the ADF tools from the repository to your project:

```powershell
$toolFiles = @(
    "adf-viewer.html",
    "markdown-to-adf.html",
    "markdown-to-adf.js",
    "adf-documentation.json",
    "example-adf.json"
)

foreach ($file in $toolFiles) {
    Copy-Item -Path "path/to/repo/$file" -Destination "tools/adf/" -Force
}
```

### Step Two: Create Conversion Script
Create a script to convert Markdown files to ADF format.

#### Sub-step 2.1: Create the Script
Create a PowerShell script named `convert-docs.ps1` in your project root:

```powershell
# Convert Markdown docs to ADF
$docsDir = "./docs"
$adfDocsDir = "./docs/adf"
$toolsDir = "./tools/adf"

# Create directories if they don't exist
if (-not (Test-Path $adfDocsDir)) {
    New-Item -ItemType Directory -Path $adfDocsDir -Force | Out-Null
}

# Convert Markdown files to ADF
$markdownFiles = Get-ChildItem -Path $docsDir -Filter "*.md" -Recurse | 
                 Where-Object { $_.FullName -notlike "*$adfDocsDir*" }
foreach ($file in $markdownFiles) {
    $relativePath = $file.FullName.Substring((Resolve-Path $docsDir).Path.Length + 1)
    $outputPath = Join-Path -Path $adfDocsDir -ChildPath ($relativePath -replace "\.md$", ".adf.json")
    
    # Create directory if it doesn't exist
    $outputDir = Split-Path -Path $outputPath -Parent
    if (-not (Test-Path $outputDir)) {
        New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
    }
    
    # Convert Markdown to ADF
    node "$toolsDir/markdown-to-adf.js" $file.FullName $outputPath
}
```

### Step Three: Convert Documentation
Convert your Markdown documentation to ADF format.

#### Sub-step 3.1: Run the Conversion Script
Execute the conversion script to convert all Markdown files in the docs directory:

```powershell
.\convert-docs.ps1
```

#### Sub-step 3.2: Verify Conversion
Check that the ADF files have been created in the `docs/adf` directory:

```powershell
Get-ChildItem -Path "docs/adf" -Recurse
```

### Step Four: View ADF Documents
View the converted ADF documents to ensure they look correct.

#### Sub-step 4.1: Open the ADF Viewer
Open the ADF viewer in your web browser:

```powershell
Start-Process ".\tools\adf\adf-viewer.html"
```

#### Sub-step 4.2: Load ADF File
In the ADF viewer:
1. Click the "Load from File" button
2. Navigate to your `docs/adf` directory
3. Select an ADF JSON file to view

### Step Five: Configure Confluence Integration (Optional)
If you want to upload your ADF documents to Confluence, configure the Confluence MCP server.

#### Sub-step 5.1: Configure MCP Server
Run the MCP server configuration script:

```powershell
.\scripts\Configure-McpServers.ps1
```

#### Sub-step 5.2: Set Up Confluence Credentials
Create or edit the `.env` file in the `mcp/adf-confluence-server` directory with your Confluence credentials:

```
CONFLUENCE_URL=https://your-instance.atlassian.net
CONFLUENCE_USERNAME=your-email@example.com
CONFLUENCE_API_TOKEN=your-api-token
```

## Troubleshooting/FAQs

### Conversion Script Fails
If the conversion script fails with a Node.js error:

1. Ensure Node.js is installed and in your PATH
2. Check that all required ADF tools are in the `tools/adf` directory
3. Verify that the Markdown files are valid and properly formatted

### ADF Viewer Shows Incorrect Formatting
If the ADF viewer doesn't display your content correctly:

1. Check your Markdown syntax for errors
2. Ensure you're using supported Markdown features
3. Try simplifying complex formatting and convert again

### Confluence Upload Fails
If uploading to Confluence fails:

1. Verify your Confluence credentials in the `.env` file
2. Check that you have permission to create/update pages in the target space
3. Ensure the Confluence MCP server is properly configured

## Additional Resources
* [Atlassian Document Format Documentation](https://developer.atlassian.com/cloud/jira/platform/apis/document/structure/)
* [Confluence REST API Documentation](https://developer.atlassian.com/cloud/confluence/rest/intro/)
* [Node.js Documentation](https://nodejs.org/en/docs/)
* [HIT Documentation Template Guide](./documentation-style-guide.md)