# ADF Integration with Documentation Mode

This guide explains how to use Atlassian Document Format (ADF) capabilities in the Documentation mode.

## Overview

The Documentation mode has been enhanced with Atlassian Document Format (ADF) capabilities, allowing you to:

1. Convert Markdown documentation to ADF format
2. View and validate ADF documents
3. Integrate documentation with Atlassian products like Confluence and Jira
4. Follow best practices for documentation-as-code with ADF

## Available Tools

The following tools are available for working with ADF:

- **markdown-to-adf.html**: Browser-based converter from Markdown to ADF
- **markdown-to-adf.js**: Command-line Node.js script for converting Markdown to ADF
- **adf-viewer.html**: Browser-based viewer for ADF documents
- **adf-documentation.json**: Comprehensive documentation on ADF format
- **example-adf.json**: Simple example of an ADF document
- **sample.md**: Sample Markdown file for testing conversion

## Converting Markdown to ADF

### Using the Web-Based Converter

1. Open `markdown-to-adf.html` in a web browser
2. Enter or paste your Markdown content in the left panel
3. Click "Convert to ADF"
4. The ADF JSON will appear in the right panel
5. Use "Copy ADF to Clipboard" to copy the result
6. Use "View in ADF Viewer" to see how it will be rendered

### Using the Command-Line Tool

1. Ensure Node.js is installed
2. Run the script:
   ```powershell
   node markdown-to-adf.js input.md [output.json]
   ```
   If output file is not specified, it will use the input filename with .json extension.

3. For batch conversion of multiple files:
   ```powershell
   Get-ChildItem -Path ./docs -Filter *.md | ForEach-Object {
       node markdown-to-adf.js $_.FullName ($_.BaseName + ".adf.json")
   }
   ```

## Viewing ADF Documents

1. Open `adf-viewer.html` in a web browser
2. Choose one of the loading options:
   - Load from File: Select an ADF JSON file
   - Paste JSON: Paste ADF JSON content and click "Render"
   - Examples: Load one of the pre-configured examples

## Integrating with Atlassian Products

### Confluence

To add ADF content to Confluence:

1. Convert your Markdown documentation to ADF using the tools above
2. Use the Confluence REST API to create or update pages with ADF content:

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

### Jira

To add ADF content to Jira:

1. Convert your Markdown documentation to ADF using the tools above
2. Use the Jira REST API to update issue fields with ADF content:

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

## Documentation-as-Code Best Practices

### Version Control Integration

1. Store ADF documentation files in your repository (e.g., in a `/docs` folder)
2. Use standard Git workflows for reviewing and updating documentation
3. Include documentation changes in pull/merge requests
4. Use the ADF Viewer to preview changes during code review

### CI/CD Pipeline Integration

1. Add documentation conversion steps to your CI/CD pipeline:
   ```yaml
   # Example GitHub Actions workflow step
   - name: Convert Documentation to ADF
     run: |
       npm install
       node scripts/convert-docs.js
   ```

2. Add validation steps to ensure ADF documents are well-formed
3. Add steps to publish documentation to Confluence or other platforms

## Example Workflow

Here's an example workflow for using ADF with the Documentation mode:

1. Write or update documentation in Markdown format
2. Convert the Markdown to ADF using the provided tools
3. View the ADF document to ensure it renders correctly
4. Store both the Markdown and ADF versions in version control
5. Set up automated processes to publish the ADF documentation to Atlassian products

## Resources

- [Official Atlassian Document Format Documentation](https://developer.atlassian.com/cloud/jira/platform/apis/document/structure/)
- [Atlassian Editor](https://atlaskit.atlassian.com/packages/editor/editor-core)
- [integrating-adf-guide.md](integrating-adf-guide.md) - Detailed guide on integrating ADF into projects