# Integrating ADF Documentation into In-Flight Projects

This guide explains how to apply Atlassian Document Format (ADF) to your existing projects and development workflows.

## Table of Contents

1. [Converting Existing Documentation to ADF](#converting-existing-documentation-to-adf)
2. [Integrating with Atlassian Products](#integrating-with-atlassian-products)
3. [Incorporating ADF into Development Workflows](#incorporating-adf-into-development-workflows)
4. [Automating Documentation Updates](#automating-documentation-updates)
5. [Best Practices](#best-practices)

## Converting Existing Documentation to ADF

### Markdown to ADF

If your existing documentation is in Markdown format:

1. **Using the Web Converter**:
   - Open `markdown-to-adf.html` in a browser
   - Paste your existing Markdown content
   - Click "Convert to ADF"
   - Copy the resulting ADF JSON or save it to a file

2. **Using the Command-Line Tool**:
   - For batch conversion of multiple files:
   ```powershell
   Get-ChildItem -Path ./docs -Filter *.md | ForEach-Object {
       node markdown-to-adf.js $_.FullName ($_.BaseName + ".adf.json")
   }
   ```

### Other Formats to ADF

For other documentation formats (HTML, Word, etc.):

1. Convert to Markdown first using appropriate tools:
   - HTML to Markdown: Use tools like Turndown.js or Pandoc
   - Word to Markdown: Use Pandoc or Word's "Save as Web Page" followed by HTML to Markdown conversion

2. Then convert the Markdown to ADF using the tools provided

## Integrating with Atlassian Products

### Confluence

To add ADF content to Confluence:

1. **Using the Confluence REST API**:
   ```javascript
   // Example code for creating a page with ADF content
   const createPage = async (title, adfContent, spaceKey, parentId) => {
     const response = await fetch('https://your-instance.atlassian.net/wiki/rest/api/content', {
       method: 'POST',
       headers: {
         'Authorization': 'Basic ' + btoa('email@example.com:api_token'),
         'Content-Type': 'application/json'
       },
       body: JSON.stringify({
         type: 'page',
         title: title,
         space: { key: spaceKey },
         ancestors: parentId ? [{ id: parentId }] : [],
         body: {
           storage: {
             value: JSON.stringify(adfContent),
             representation: 'atlas_doc_format'
           }
         }
       })
     });
     return response.json();
   };
   ```

2. **Using the Confluence Cloud UI**:
   - Some Confluence editors support pasting ADF JSON directly
   - Alternatively, use the Atlassian SDK to create a custom macro that renders ADF content

### Jira

To add ADF content to Jira:

1. **Using the Jira REST API**:
   ```javascript
   // Example code for updating a field with ADF content
   const updateDescription = async (issueKey, adfContent) => {
     const response = await fetch(`https://your-instance.atlassian.net/rest/api/3/issue/${issueKey}`, {
       method: 'PUT',
       headers: {
         'Authorization': 'Basic ' + btoa('email@example.com:api_token'),
         'Content-Type': 'application/json'
       },
       body: JSON.stringify({
         fields: {
           description: adfContent
         }
       })
     });
     return response.status;
   };
   ```

## Incorporating ADF into Development Workflows

### Version Control Integration

1. **Store ADF files alongside code**:
   - Keep ADF documentation files in your repository (e.g., in a `/docs` folder)
   - Use standard Git workflows for reviewing and updating documentation

2. **Documentation Review Process**:
   - Include documentation changes in pull/merge requests
   - Use the ADF Viewer (`adf-viewer.html`) to preview changes during code review

### CI/CD Pipeline Integration

1. **Automated Documentation Building**:
   - Add documentation conversion steps to your CI/CD pipeline:
   ```yaml
   # Example GitHub Actions workflow step
   - name: Convert Documentation to ADF
     run: |
       npm install
       node scripts/convert-docs.js
   ```

2. **Documentation Validation**:
   - Add validation steps to ensure ADF documents are well-formed:
   ```javascript
   // Example validation script
   const validateADF = (adfContent) => {
     // Basic structure validation
     if (!adfContent.version || !adfContent.type || !adfContent.content) {
       return false;
     }
     // More detailed validation as needed
     return true;
   };
   ```

3. **Automated Publishing**:
   - Add steps to publish documentation to Confluence or other platforms:
   ```powershell
   # Example PowerShell script to publish docs to Confluence
   $files = Get-ChildItem -Path ./docs -Filter *.adf.json
   foreach ($file in $files) {
       node scripts/publish-to-confluence.js $file.FullName
   }
   ```

## Automating Documentation Updates

### Documentation Generation from Code

1. **Generate API Documentation**:
   - Extract API information from code comments
   - Convert to ADF format for publishing

   ```javascript
   // Example: Converting JSDoc to ADF
   const jsdoc2adf = require('./jsdoc2adf');
   const sourceFiles = glob.sync('src/**/*.js');
   
   sourceFiles.forEach(file => {
     const jsdocData = extractJSDoc(file);
     const adfContent = jsdoc2adf(jsdocData);
     fs.writeFileSync(
       file.replace(/\.js$/, '.adf.json').replace(/^src/, 'docs'),
       JSON.stringify(adfContent, null, 2)
     );
   });
   ```

2. **Sync Documentation with Code Changes**:
   - Set up Git hooks to flag documentation that needs updating when related code changes
   - Create scripts to identify documentation affected by code changes

### Scheduled Documentation Reviews

1. **Set up automated reminders**:
   - Create scheduled tasks to review documentation periodically
   - Flag documentation that hasn't been updated in a specified time period

2. **Documentation health checks**:
   - Create scripts to analyze documentation coverage
   - Generate reports on documentation freshness and completeness

## Best Practices

1. **Maintain a Single Source of Truth**:
   - Keep documentation in a format that can be easily converted to ADF
   - Use automation to ensure consistency across platforms

2. **Document-as-Code Approach**:
   - Treat documentation with the same rigor as code
   - Include documentation changes in code reviews
   - Write tests for documentation generation scripts

3. **Incremental Adoption**:
   - Start with converting the most important documentation to ADF
   - Gradually expand to cover more documentation as processes mature

4. **Training and Guidelines**:
   - Provide team training on ADF format and tools
   - Create style guides for consistent documentation

5. **Feedback Loop**:
   - Collect feedback on documentation usability
   - Continuously improve documentation processes

## Example Implementation Script

Here's a PowerShell script that you can adapt to integrate ADF documentation into your project:

```powershell
# integrating-adf.ps1

# 1. Set up directories
$docsDir = "./docs"
$adfDocsDir = "./docs/adf"
$toolsDir = "./tools/adf"

if (-not (Test-Path $adfDocsDir)) {
    New-Item -ItemType Directory -Path $adfDocsDir -Force
}

if (-not (Test-Path $toolsDir)) {
    New-Item -ItemType Directory -Path $toolsDir -Force
}

# 2. Copy ADF tools to project
Copy-Item -Path "adf-viewer.html" -Destination "$toolsDir/"
Copy-Item -Path "markdown-to-adf.html" -Destination "$toolsDir/"
Copy-Item -Path "markdown-to-adf.js" -Destination "$toolsDir/"

# 3. Convert existing Markdown docs to ADF
$markdownFiles = Get-ChildItem -Path $docsDir -Filter "*.md" -Recurse
foreach ($file in $markdownFiles) {
    $relativePath = $file.FullName.Substring($docsDir.Length + 1)
    $outputPath = Join-Path -Path $adfDocsDir -ChildPath ($relativePath -replace "\.md$", ".adf.json")
    
    # Create directory if it doesn't exist
    $outputDir = Split-Path -Path $outputPath -Parent
    if (-not (Test-Path $outputDir)) {
        New-Item -ItemType Directory -Path $outputDir -Force
    }
    
    # Convert Markdown to ADF
    node "$toolsDir/markdown-to-adf.js" $file.FullName $outputPath
    Write-Host "Converted $($file.FullName) to $outputPath"
}

# 4. Add documentation to .gitignore exceptions
$gitignorePath = "./.gitignore"
if (Test-Path $gitignorePath) {
    $gitignoreContent = Get-Content $gitignorePath
    if (-not ($gitignoreContent -contains "!$toolsDir/")) {
        Add-Content -Path $gitignorePath -Value "!$toolsDir/"
    }
    if (-not ($gitignoreContent -contains "!$adfDocsDir/")) {
        Add-Content -Path $gitignorePath -Value "!$adfDocsDir/"
    }
}

# 5. Create a README for the ADF docs
$readmePath = "$adfDocsDir/README.md"
$readmeContent = @"
# ADF Documentation

This directory contains documentation in Atlassian Document Format (ADF).

## Viewing Documentation

To view these documents:

1. Open \`../tools/adf/adf-viewer.html\` in a web browser
2. Click "Load from File" and select an ADF JSON file from this directory

## Updating Documentation

When updating documentation:

1. Edit the original Markdown files in the parent directory
2. Run \`integrating-adf.ps1\` to regenerate the ADF files
3. Commit both the Markdown and ADF versions to version control
"@

Set-Content -Path $readmePath -Value $readmeContent

Write-Host "ADF documentation integration complete!"
```

To use this script:

1. Save it as `integrating-adf.ps1` in your project root
2. Run it with PowerShell:
   ```powershell
   .\integrating-adf.ps1
   ```
3. Follow the instructions in the generated README to work with your ADF documentation