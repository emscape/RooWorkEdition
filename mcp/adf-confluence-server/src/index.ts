import { McpServer, McpTool, McpResource } from '@modelcontextprotocol/sdk';
import axios from 'axios';
import { marked } from 'marked';
import fs from 'fs';
import path from 'path';

// Configuration interface
interface ConfluenceConfig {
  baseUrl: string;
  username: string;
  apiToken: string;
  spaceKey: string;
}

// Load configuration from environment variables
const config: ConfluenceConfig = {
  baseUrl: process.env.CONFLUENCE_BASE_URL || '',
  username: process.env.CONFLUENCE_USERNAME || '',
  apiToken: process.env.CONFLUENCE_API_TOKEN || '',
  spaceKey: process.env.CONFLUENCE_SPACE_KEY || ''
};

// Validate configuration
if (!config.baseUrl || !config.username || !config.apiToken || !config.spaceKey) {
  console.error('Missing required environment variables for Confluence integration.');
  console.error('Please set CONFLUENCE_BASE_URL, CONFLUENCE_USERNAME, CONFLUENCE_API_TOKEN, and CONFLUENCE_SPACE_KEY.');
  process.exit(1);
}

// Create MCP server
const server = new McpServer({
  name: 'adf-confluence-server',
  description: 'MCP server for ADF conversion and Confluence integration'
});

// Convert Markdown to ADF
async function markdownToAdf(markdown: string): Promise<any> {
  // Basic conversion using marked to get HTML
  const html = marked(markdown);
  
  // Convert HTML to ADF (simplified version)
  // In a real implementation, you would use a more sophisticated conversion
  const adf = {
    version: 1,
    type: "doc",
    content: [
      {
        type: "paragraph",
        content: [
          {
            type: "text",
            text: "This is a simplified ADF conversion. In a real implementation, you would use a more sophisticated conversion."
          }
        ]
      },
      {
        type: "paragraph",
        content: [
          {
            type: "text",
            text: markdown
          }
        ]
      }
    ]
  };
  
  return adf;
}

// Tool: Convert Markdown to ADF
server.defineTool({
  name: 'convertMarkdownToAdf',
  description: 'Convert Markdown content to Atlassian Document Format (ADF)',
  inputSchema: {
    type: 'object',
    properties: {
      markdown: {
        type: 'string',
        description: 'Markdown content to convert'
      }
    },
    required: ['markdown']
  },
  execute: async ({ markdown }) => {
    try {
      const adf = await markdownToAdf(markdown);
      return { adf };
    } catch (error) {
      console.error('Error converting Markdown to ADF:', error);
      throw new Error(`Failed to convert Markdown to ADF: ${error.message}`);
    }
  }
});

// Tool: Upload content to Confluence
server.defineTool({
  name: 'uploadToConfluence',
  description: 'Upload content to Confluence as a new page',
  inputSchema: {
    type: 'object',
    properties: {
      title: {
        type: 'string',
        description: 'Title of the Confluence page'
      },
      content: {
        type: 'string',
        description: 'Content in Markdown format'
      },
      parentId: {
        type: 'string',
        description: 'ID of the parent page (optional)',
        default: ''
      }
    },
    required: ['title', 'content']
  },
  execute: async ({ title, content, parentId }) => {
    try {
      // Convert content to ADF
      const adf = await markdownToAdf(content);
      
      // Create request body
      const body: any = {
        type: 'page',
        title,
        space: {
          key: config.spaceKey
        },
        body: {
          storage: {
            value: JSON.stringify(adf),
            representation: 'atlas_doc_format'
          }
        }
      };
      
      // Add parent page if specified
      if (parentId) {
        body.ancestors = [{ id: parentId }];
      }
      
      // Create auth header
      const auth = Buffer.from(`${config.username}:${config.apiToken}`).toString('base64');
      
      // Make API request
      const response = await axios.post(
        `${config.baseUrl}/wiki/rest/api/content`,
        body,
        {
          headers: {
            'Authorization': `Basic ${auth}`,
            'Content-Type': 'application/json'
          }
        }
      );
      
      return {
        id: response.data.id,
        title: response.data.title,
        url: `${config.baseUrl}/wiki${response.data._links.webui}`
      };
    } catch (error) {
      console.error('Error uploading to Confluence:', error);
      throw new Error(`Failed to upload to Confluence: ${error.response?.data?.message || error.message}`);
    }
  }
});

// Tool: Get Confluence page
server.defineTool({
  name: 'getConfluencePage',
  description: 'Get a Confluence page by ID',
  inputSchema: {
    type: 'object',
    properties: {
      pageId: {
        type: 'string',
        description: 'ID of the Confluence page'
      }
    },
    required: ['pageId']
  },
  execute: async ({ pageId }) => {
    try {
      // Create auth header
      const auth = Buffer.from(`${config.username}:${config.apiToken}`).toString('base64');
      
      // Make API request
      const response = await axios.get(
        `${config.baseUrl}/wiki/rest/api/content/${pageId}?expand=body.storage`,
        {
          headers: {
            'Authorization': `Basic ${auth}`,
            'Content-Type': 'application/json'
          }
        }
      );
      
      return {
        id: response.data.id,
        title: response.data.title,
        content: response.data.body.storage.value,
        url: `${config.baseUrl}/wiki${response.data._links.webui}`
      };
    } catch (error) {
      console.error('Error getting Confluence page:', error);
      throw new Error(`Failed to get Confluence page: ${error.response?.data?.message || error.message}`);
    }
  }
});

// Tool: Search Confluence
server.defineTool({
  name: 'searchConfluence',
  description: 'Search for content in Confluence',
  inputSchema: {
    type: 'object',
    properties: {
      query: {
        type: 'string',
        description: 'Search query'
      },
      limit: {
        type: 'number',
        description: 'Maximum number of results to return',
        default: 10
      }
    },
    required: ['query']
  },
  execute: async ({ query, limit }) => {
    try {
      // Create auth header
      const auth = Buffer.from(`${config.username}:${config.apiToken}`).toString('base64');
      
      // Make API request
      const response = await axios.get(
        `${config.baseUrl}/wiki/rest/api/content/search?cql=space="${config.spaceKey}" AND text~"${query}"&limit=${limit}`,
        {
          headers: {
            'Authorization': `Basic ${auth}`,
            'Content-Type': 'application/json'
          }
        }
      );
      
      return {
        results: response.data.results.map((result: any) => ({
          id: result.id,
          title: result.title,
          url: `${config.baseUrl}/wiki${result._links.webui}`
        }))
      };
    } catch (error) {
      console.error('Error searching Confluence:', error);
      throw new Error(`Failed to search Confluence: ${error.response?.data?.message || error.message}`);
    }
  }
});

// Start the server
server.start();