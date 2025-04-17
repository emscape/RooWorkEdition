# Setup Confluence Integration
# This script sets up the Confluence integration for the RooFlow project

# Configuration
$configDir = "./config"
$configFile = "$configDir/confluence-config.json"
$configTemplateFile = "$configDir/confluence-config.template.json"
$mcpServerDir = "./mcp/adf-confluence-server"
$mcpServerEnvFile = "$mcpServerDir/.env"
$mcpConfigFile = "./.roo/mcp-config.json"

# Function to prompt for Confluence credentials
function Get-ConfluenceCredentials {
    Write-Host "Please provide your Confluence credentials:" -ForegroundColor Cyan
    
    $confluenceUrl = Read-Host "Enter your Confluence URL (e.g., https://your-domain.atlassian.net)"
    $email = Read-Host "Enter your Atlassian account email"
    $apiToken = Read-Host "Enter your Atlassian API token (generate one at https://id.atlassian.com/manage-profile/security/api-tokens)"
    $spaceKey = Read-Host "Enter your Confluence space key"
    $parentId = Read-Host "Enter parent page ID (optional, press Enter to skip)"
    
    return @{
        confluenceUrl = $confluenceUrl
        email = $email
        apiToken = $apiToken
        spaceKey = $spaceKey
        parentId = $parentId
    }
}

# Function to update the configuration files
function Update-ConfigFiles {
    param (
        [hashtable]$credentials
    )
    
    # Update confluence-config.json
    if (Test-Path $configFile) {
        $config = Get-Content $configFile | ConvertFrom-Json
    } else {
        if (Test-Path $configTemplateFile) {
            $config = Get-Content $configTemplateFile | ConvertFrom-Json
        } else {
            $config = [PSCustomObject]@{
                confluenceUrl = ""
                email = ""
                apiToken = ""
                spaceKey = ""
                parentId = ""
            }
        }
    }
    
    $config.confluenceUrl = $credentials.confluenceUrl
    $config.email = $credentials.email
    $config.apiToken = $credentials.apiToken
    $config.spaceKey = $credentials.spaceKey
    $config.parentId = $credentials.parentId
    
    # Create config directory if it doesn't exist
    if (-not (Test-Path $configDir)) {
        New-Item -ItemType Directory -Path $configDir -Force | Out-Null
    }
    
    # Save the updated config
    $config | ConvertTo-Json -Depth 5 | Set-Content -Path $configFile -Encoding UTF8
    Write-Host "Updated $configFile" -ForegroundColor Green
    
    # Update MCP server .env file
    $envContent = @"
# Confluence Configuration

# Confluence base URL (e.g., https://your-domain.atlassian.net)
CONFLUENCE_BASE_URL=$($credentials.confluenceUrl)

# Confluence username (your Atlassian account email)
CONFLUENCE_USERNAME=$($credentials.email)

# Confluence API token
# Generate one at https://id.atlassian.com/manage-profile/security/api-tokens
CONFLUENCE_API_TOKEN=$($credentials.apiToken)

# Confluence space key
# This is the short key for your Confluence space (e.g., "TEAM" or "DOCS")
CONFLUENCE_SPACE_KEY=$($credentials.spaceKey)
"@
    
    # Create MCP server directory if it doesn't exist
    if (-not (Test-Path $mcpServerDir)) {
        Write-Host "MCP server directory not found at $mcpServerDir" -ForegroundColor Yellow
        Write-Host "Please run the setup-adf-workflow.ps1 script first to set up the ADF workflow" -ForegroundColor Yellow
    } else {
        Set-Content -Path $mcpServerEnvFile -Value $envContent -Encoding UTF8
        Write-Host "Updated $mcpServerEnvFile" -ForegroundColor Green
    }
    
    # Update MCP config file
    if (Test-Path $mcpConfigFile) {
        $mcpConfig = Get-Content $mcpConfigFile | ConvertFrom-Json
        
        # Check if confluence server is defined
        if ($mcpConfig.mcpServers.PSObject.Properties.Name -contains "confluence") {
            $mcpConfig.mcpServers.confluence.enabled = $true
        } else {
            # Add confluence server if it doesn't exist
            $confluenceServer = [PSCustomObject]@{
                description = "Provides integration with Atlassian Confluence."
                allowedTools = @("convertMarkdownToAdf", "uploadToConfluence", "getConfluencePage", "searchConfluence")
                enabled = $true
            }
            
            # Add the confluence server to the config
            $mcpConfig.mcpServers | Add-Member -MemberType NoteProperty -Name "confluence" -Value $confluenceServer
        }
        
        # Save the updated config
        $mcpConfig | ConvertTo-Json -Depth 5 | Set-Content -Path $mcpConfigFile -Encoding UTF8
        Write-Host "Updated $mcpConfigFile" -ForegroundColor Green
    } else {
        Write-Host "MCP config file not found at $mcpConfigFile" -ForegroundColor Yellow
        Write-Host "Please run the setup-adf-workflow.ps1 script first to set up the ADF workflow" -ForegroundColor Yellow
    }
}

# Function to install and configure the MCP server
function Install-McpServer {
    if (Test-Path $mcpServerDir) {
        Write-Host "Installing and configuring the Confluence MCP server..." -ForegroundColor Cyan
        
        # Change to the MCP server directory
        Push-Location $mcpServerDir
        
        # Run the installation script
        try {
            & ./install.ps1
            Write-Host "Confluence MCP server installed successfully" -ForegroundColor Green
        } catch {
            Write-Host "Error installing Confluence MCP server: $_" -ForegroundColor Red
        }
        
        # Return to the original directory
        Pop-Location
    } else {
        Write-Host "MCP server directory not found at $mcpServerDir" -ForegroundColor Yellow
        Write-Host "Please run the setup-adf-workflow.ps1 script first to set up the ADF workflow" -ForegroundColor Yellow
    }
}

# Main script
Write-Host "Confluence Integration Setup" -ForegroundColor Cyan
Write-Host "==========================" -ForegroundColor Cyan

# Check if configuration files exist
$configExists = Test-Path $configFile
$mcpServerEnvExists = Test-Path $mcpServerEnvFile

if ($configExists -and $mcpServerEnvExists) {
    $updateConfig = Read-Host "Configuration files already exist. Do you want to update them? (y/n)"
    if ($updateConfig -ne "y") {
        Write-Host "Skipping configuration update" -ForegroundColor Yellow
        $credentials = $null
    } else {
        $credentials = Get-ConfluenceCredentials
    }
} else {
    $credentials = Get-ConfluenceCredentials
}

if ($null -ne $credentials) {
    Update-ConfigFiles -credentials $credentials
}

# Install and configure the MCP server
$installMcpServer = Read-Host "Do you want to install and configure the Confluence MCP server? (y/n)"
if ($installMcpServer -eq "y") {
    Install-McpServer
}

# Final instructions
Write-Host "`nConfluence Integration Setup Complete!" -ForegroundColor Cyan
Write-Host "`nNext steps:" -ForegroundColor White
Write-Host "1. Write your documentation in Markdown format in the ./docs directory" -ForegroundColor White
Write-Host "2. Run .\convert-docs.ps1 to convert Markdown to ADF" -ForegroundColor White
Write-Host "3. Use one of the following methods to upload to Confluence:" -ForegroundColor White
Write-Host "   a. PowerShell script: .\confluence-uploader.ps1" -ForegroundColor White
Write-Host "   b. MCP server: Start the server with 'cd $mcpServerDir && npm start'" -ForegroundColor White
Write-Host "      Then use Roo to interact with Confluence" -ForegroundColor White
Write-Host "`nFor more information, see docs/confluence-uploader-setup-guide.md" -ForegroundColor White