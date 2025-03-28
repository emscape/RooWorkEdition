# Confluence ADF Uploader
# This script uploads ADF content to Confluence

# Configuration - You'll need to fill these in
$confluenceUrl = "https://blueshieldca.atlassian.net"
$email = "your-email@example.com"  # Your Atlassian account email
$apiToken = "your-api-token"       # Your Atlassian API token
$spaceKey = "SPACE"                # The key of the Confluence space
$parentId = ""                     # Optional: ID of the parent page (leave empty for top-level page)

# To get an API token:
# 1. Go to https://id.atlassian.com/manage-profile/security/api-tokens
# 2. Click "Create API token"
# 3. Give it a name like "Confluence ADF Uploader"
# 4. Copy the token value

# Function to convert Markdown to ADF
function Convert-MarkdownToADF {
    param (
        [string]$markdownPath
    )
    
    $adfPath = $markdownPath -replace "\.md$", ".adf.json"
    
    try {
        node "./tools/adf/markdown-to-adf.js" $markdownPath $adfPath
        return $adfPath
    } catch {
        Write-Host "Error converting Markdown to ADF: $_" -ForegroundColor Red
        exit 1
    }
}

# Function to upload ADF content to Confluence
function Upload-ToConfluence {
    param (
        [string]$title,
        [string]$adfPath
    )
    
    # Read the ADF content
    $adfContent = Get-Content $adfPath -Raw | ConvertFrom-Json
    
    # Create the request body
    $body = @{
        type = "page"
        title = $title
        space = @{
            key = $spaceKey
        }
        body = @{
            storage = @{
                value = (ConvertTo-Json $adfContent -Depth 100 -Compress)
                representation = "atlas_doc_format"
            }
        }
    }
    
    # Add parent page if specified
    if ($parentId) {
        $body.ancestors = @(@{id = $parentId})
    }
    
    # Convert to JSON
    $jsonBody = ConvertTo-Json $body -Depth 100
    
    # Create auth header
    $base64Auth = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("$($email):$($apiToken)"))
    $headers = @{
        "Authorization" = "Basic $base64Auth"
        "Content-Type" = "application/json"
    }
    
    # Make the API request
    try {
        $response = Invoke-RestMethod -Uri "$confluenceUrl/wiki/rest/api/content" -Method Post -Headers $headers -Body $jsonBody
        return $response
    } catch {
        Write-Host "Error uploading to Confluence: $_" -ForegroundColor Red
        Write-Host "Response: $($_.Exception.Response.GetResponseStream())" -ForegroundColor Red
        exit 1
    }
}

# Main script
Write-Host "Confluence ADF Uploader" -ForegroundColor Cyan
Write-Host "======================" -ForegroundColor Cyan

# Check if configuration is set
if ($apiToken -eq "your-api-token" -or $email -eq "your-email@example.com") {
    Write-Host "Please edit this script to set your Confluence URL, email, API token, and space key." -ForegroundColor Yellow
    exit 1
}

# Get the Markdown file
$markdownPath = Read-Host "Enter the path to the Markdown file to upload"
if (-not (Test-Path $markdownPath)) {
    Write-Host "File not found: $markdownPath" -ForegroundColor Red
    exit 1
}

# Get the page title
$title = Read-Host "Enter the title for the Confluence page"

# Convert Markdown to ADF
Write-Host "Converting Markdown to ADF..." -ForegroundColor Cyan
$adfPath = Convert-MarkdownToADF $markdownPath
Write-Host "Converted to ADF: $adfPath" -ForegroundColor Green

# Upload to Confluence
Write-Host "Uploading to Confluence..." -ForegroundColor Cyan
$response = Upload-ToConfluence $title $adfPath

# Display result
Write-Host "Successfully created Confluence page!" -ForegroundColor Green
Write-Host "Title: $($response.title)" -ForegroundColor White
Write-Host "ID: $($response.id)" -ForegroundColor White
Write-Host "URL: $confluenceUrl/wiki$($response._links.webui)" -ForegroundColor White