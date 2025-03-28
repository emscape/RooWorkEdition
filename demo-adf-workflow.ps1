# Demonstrate ADF Documentation Workflow
# This script demonstrates the ADF documentation workflow in action

# Configuration
$demoDir = "./demo-adf"
$toolsDir = "./tools/adf"
$sampleFile = "demo-doc.md"
$adfFile = "demo-doc.adf.json"

# Create demo directory
if (-not (Test-Path $demoDir)) {
    New-Item -ItemType Directory -Path $demoDir -Force | Out-Null
    Write-Host "Created demo directory: $demoDir" -ForegroundColor Green
}

# Create tools directory if it doesn't exist
if (-not (Test-Path $toolsDir)) {
    New-Item -ItemType Directory -Path $toolsDir -Force | Out-Null
    Write-Host "Created tools directory: $toolsDir" -ForegroundColor Green
    
    # Copy ADF tools to tools directory
    $toolFiles = @(
        "adf-viewer.html",
        "markdown-to-adf.html",
        "markdown-to-adf.js",
        "adf-documentation.json",
        "example-adf.json"
    )
    
    foreach ($file in $toolFiles) {
        if (Test-Path $file) {
            Copy-Item -Path $file -Destination "$toolsDir/" -Force
            Write-Host "Copied $file to $toolsDir/" -ForegroundColor Green
        } else {
            Write-Host "Warning: $file not found in current directory" -ForegroundColor Yellow
        }
    }
}

# Create a sample Markdown document
$samplePath = "$demoDir/$sampleFile"
$sampleContent = @"
# ADF Documentation Demo

This is a demonstration of the ADF documentation workflow.

## What is ADF?

Atlassian Document Format (ADF) is a JSON-based format used by Atlassian products like Confluence and Jira for rich text content.

## Features

- **Rich Text**: Support for formatting, lists, tables, and more
- **JSON-Based**: Structured format that can be parsed and manipulated programmatically
- **Atlassian Integration**: Works seamlessly with Confluence and Jira

## Code Example

```javascript
// Example of creating an ADF document
const adfDoc = {
  version: 1,
  type: 'doc',
  content: [
    {
      type: 'heading',
      attrs: { level: 1 },
      content: [{ type: 'text', text: 'Hello, ADF!' }]
    },
    {
      type: 'paragraph',
      content: [{ type: 'text', text: 'This is a simple ADF document.' }]
    }
  ]
};
```

## Next Steps

1. Convert this Markdown to ADF
2. View the ADF document in the ADF Viewer
3. Integrate with Atlassian products

For more information, see the [Atlassian Developer Documentation](https://developer.atlassian.com/cloud/jira/platform/apis/document/structure/).
"@

Set-Content -Path $samplePath -Value $sampleContent
Write-Host "Created sample Markdown file: $samplePath" -ForegroundColor Green

# Step 1: Convert Markdown to ADF
Write-Host "`nStep 1: Converting Markdown to ADF..." -ForegroundColor Cyan
$adfPath = "$demoDir/$adfFile"

try {
    node "$toolsDir/markdown-to-adf.js" $samplePath $adfPath
    Write-Host "Successfully converted Markdown to ADF: $adfPath" -ForegroundColor Green
    
    # Display the first few lines of the ADF file
    Write-Host "`nPreview of the ADF file:" -ForegroundColor Cyan
    Get-Content $adfPath -Head 20 | ForEach-Object { Write-Host "  $_" }
    Write-Host "  ..." -ForegroundColor DarkGray
} catch {
    Write-Host "Error converting Markdown to ADF: $_" -ForegroundColor Red
    exit 1
}

# Step 2: View the ADF document
Write-Host "`nStep 2: Viewing the ADF document..." -ForegroundColor Cyan
Write-Host "To view the ADF document, open the following file in your browser:" -ForegroundColor White
Write-Host "  $toolsDir/adf-viewer.html" -ForegroundColor White
Write-Host "Then click 'Load from File' and select:" -ForegroundColor White
Write-Host "  $adfPath" -ForegroundColor White

# Try to open the ADF viewer automatically
try {
    Write-Host "`nAttempting to open the ADF viewer automatically..." -ForegroundColor Cyan
    Start-Process "$toolsDir/adf-viewer.html"
    Write-Host "ADF viewer opened. Please use 'Load from File' to open: $adfPath" -ForegroundColor Green
} catch {
    Write-Host "Could not open the ADF viewer automatically. Please open it manually." -ForegroundColor Yellow
}

# Step 3: Integration with Atlassian products
Write-Host "`nStep 3: Integration with Atlassian products" -ForegroundColor Cyan
Write-Host "To integrate with Atlassian products:" -ForegroundColor White
Write-Host "1. Use the Confluence REST API to create pages with ADF content" -ForegroundColor White
Write-Host "2. Use the Jira REST API to update issue fields with ADF content" -ForegroundColor White
Write-Host "3. Set up automated workflows to keep documentation in sync" -ForegroundColor White

# Final instructions
Write-Host "`nDemo Complete!" -ForegroundColor Cyan
Write-Host "You have successfully:" -ForegroundColor White
Write-Host "1. Created a Markdown document: $samplePath" -ForegroundColor White
Write-Host "2. Converted it to ADF format: $adfPath" -ForegroundColor White
Write-Host "3. Learned how to view and integrate ADF content" -ForegroundColor White
Write-Host "`nFor more information, see adf-integration-guide.md" -ForegroundColor White