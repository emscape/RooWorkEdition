# Confluence MCP Server

This is a Model Context Protocol (MCP) server for integrating with Atlassian Confluence. It provides tools for converting Markdown to Atlassian Document Format (ADF) and interacting with Confluence pages.

## Features

- Convert Markdown to ADF
- Upload content to Confluence
- Retrieve Confluence pages
- Search Confluence content

## Setup

### Prerequisites

- Node.js 16 or later
- npm or yarn
- Atlassian Confluence account with API token

### Installation

1. Install dependencies:

```bash
cd mcp/adf-confluence-server
npm install
```

2. Configure environment variables:

```bash
cp .env.template .env
```

Edit the `.env` file and fill in your Confluence details:

```
CONFLUENCE_BASE_URL=https://your-domain.atlassian.net
CONFLUENCE_USERNAME=your-email@example.com
CONFLUENCE_API_TOKEN=your-api-token
CONFLUENCE_SPACE_KEY=SPACE
```

To get an API token:
1. Go to https://id.atlassian.com/manage-profile/security/api-tokens
2. Click "Create API token"
3. Give it a name like "Confluence MCP Server"
4. Copy the token value

### Building

```bash
npm run build
```

### Running

```bash
npm start
```

## Usage

Once the server is running, it will be available as an MCP server in Roo. You can use the following tools:

### convertMarkdownToAdf

Converts Markdown content to Atlassian Document Format (ADF).

```json
{
  "markdown": "# Hello World\n\nThis is a test."
}
```

### uploadToConfluence

Uploads content to Confluence as a new page.

```json
{
  "title": "My Page Title",
  "content": "# Hello World\n\nThis is a test.",
  "parentId": "12345" // Optional
}
```

### getConfluencePage

Retrieves a Confluence page by ID.

```json
{
  "pageId": "12345"
}
```

### searchConfluence

Searches for content in Confluence.

```json
{
  "query": "search term",
  "limit": 10 // Optional, defaults to 10
}
```

## Integration with Roo

To integrate this MCP server with Roo, add the following to your `.roo/mcp-config.json` file:

```json
{
  "mcpServers": {
    "confluence": {
      "enabled": true,
      "description": "Provides integration with Atlassian Confluence.",
      "allowedTools": [
        "convertMarkdownToAdf",
        "uploadToConfluence",
        "getConfluencePage",
        "searchConfluence"
      ]
    }
  }
}
```

Then run the Configure-McpServers.ps1 script to enable the server:

```powershell
.\scripts\Configure-McpServers.ps1