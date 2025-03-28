# Sample Markdown Document

This is a sample Markdown document that demonstrates the features supported by the Markdown to ADF converter.

## Text Formatting

You can use **bold text** and *italic text* to emphasize important points. You can also use `inline code` for technical terms or code snippets.

## Lists

### Bullet Lists

- First item
- Second item
- Third item with **bold text**

### Numbered Lists

1. First step
2. Second step
3. Third step with *italic text*

## Code Blocks

```javascript
// This is a JavaScript code block
function greet(name) {
  return `Hello, ${name}!`;
}

console.log(greet('Atlassian'));
```

```python
# This is a Python code block
def greet(name):
    return f"Hello, {name}!"

print(greet("Atlassian"))
```

## Links

You can visit [Atlassian](https://www.atlassian.com) for more information about Confluence and Jira.

## Combining Features

You can combine features like **bold text with [links](https://www.atlassian.com)** or *italic text with `inline code`*.

## Using the Tools

To convert this Markdown file to ADF:

1. Use the web-based converter:
   - Open `markdown-to-adf.html` in your browser
   - Paste this content into the Markdown input
   - Click "Convert to ADF"

2. Use the command-line tool:
   ```
   node markdown-to-adf.js sample.md sample-adf.json
   ```

3. View the result:
   - Open `adf-viewer.html` in your browser
   - Load the generated ADF file