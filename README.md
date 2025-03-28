# Atlassian Document Format (ADF) Toolkit

This toolkit provides resources and tools for working with Atlassian Document Format (ADF), the JSON-based format used by Atlassian products like Confluence and Jira for rich text content.

## Contents

- `adf-documentation.json` - Comprehensive documentation on ADF format in ADF format itself
- `adf-viewer.html` - Browser-based viewer for ADF documents
- `markdown-to-adf.html` - Browser-based converter from Markdown to ADF
- `markdown-to-adf.js` - Command-line Node.js script for converting Markdown to ADF
- `sample.md` - Sample Markdown file for testing conversion
- `example-adf.json` - Simple example of an ADF document

## ADF Documentation

The `adf-documentation.json` file contains comprehensive documentation on the ADF format, including:

- Basic structure
- Common elements (headings, paragraphs, lists, etc.)
- Text formatting
- Code blocks
- Tables
- Links
- Panels
- Advanced features

You can view this documentation using the ADF Viewer.

## ADF Viewer

The `adf-viewer.html` file provides a browser-based viewer for ADF documents. It allows you to:

- Load ADF JSON files
- Paste ADF JSON directly
- View pre-loaded examples
- See how ADF documents will be rendered

To use the viewer:

1. Open `adf-viewer.html` in a web browser
2. Choose one of the loading options:
   - Load from File: Select an ADF JSON file
   - Paste JSON: Paste ADF JSON content and click "Render"
   - Examples: Load one of the pre-configured examples

## Markdown to ADF Converter (Browser)

The `markdown-to-adf.html` file provides a browser-based converter from Markdown to ADF. It allows you to:

- Enter Markdown text
- Convert it to ADF JSON
- Copy the ADF JSON to clipboard
- View the result in the ADF Viewer

Supported Markdown features:
- Headings (# to ######)
- Paragraphs
- Bold (**text**)
- Italic (*text*)
- Code blocks (```language)
- Inline code (`code`)
- Bullet lists
- Numbered lists
- Links [text](url)

To use the converter:

1. Open `markdown-to-adf.html` in a web browser
2. Enter or paste Markdown in the left panel
3. Click "Convert to ADF"
4. The ADF JSON will appear in the right panel
5. Use "Copy ADF to Clipboard" to copy the result
6. Use "View in ADF Viewer" to see how it will be rendered

## Markdown to ADF Converter (Command Line)

The `markdown-to-adf.js` file provides a command-line Node.js script for converting Markdown to ADF. This is useful for batch processing or integration with other tools.

To use the command-line converter:

1. Ensure Node.js is installed
2. Make the script executable (on Unix-like systems):
   ```
   chmod +x markdown-to-adf.js
   ```
3. Run the script:
   ```
   node markdown-to-adf.js input.md [output.json]
   ```
   If output file is not specified, it will use the input filename with .json extension.

## Sample Files

- `sample.md` - A sample Markdown file demonstrating the features supported by the converter
- `example-adf.json` - A simple example of an ADF document

## Usage Examples

### Convert Markdown to ADF and View the Result

1. Open `markdown-to-adf.html` in a browser
2. Enter or paste Markdown content
3. Click "Convert to ADF"
4. Click "View in ADF Viewer" to see the rendered result

### Convert Markdown to ADF via Command Line

```
node markdown-to-adf.js sample.md sample-adf.json
```

### View an ADF Document

1. Open `adf-viewer.html` in a browser
2. Click "Load from File" and select your ADF JSON file
3. The document will be rendered in the viewer

## Resources

- [Official Atlassian Document Format Documentation](https://developer.atlassian.com/cloud/jira/platform/apis/document/structure/)
- [Atlassian Editor](https://atlaskit.atlassian.com/packages/editor/editor-core)