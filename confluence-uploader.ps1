# Confluence ADF Uploader
# This script uploads ADF content to Confluence

param(
    [Parameter(Mandatory=$false)]
    [string]$confluenceUrl = "https://blueshieldca.atlassian.net",
    
    [Parameter(Mandatory=$false)]
    [string]$email = "your-email@example.com",  # Your Atlassian account email
    
    [Parameter(Mandatory=$false)]
    [string]$apiToken = "your-api-token",       # Your Atlassian API token
    
    [Parameter(Mandatory=$false)]
    [string]$spaceKey = "SPACE",                # The key of the Confluence space
    
    [Parameter(Mandatory=$false)]
    [string]$parentId = "",                     # Optional: ID of the parent page (leave empty for top-level page)
    
    [Parameter(Mandatory=$false)]
    [string]$adfPath = "",                      # Path to a specific ADF file to upload (leave empty to be prompted)
    
    [Parameter(Mandatory=$false)]
    [switch]$uploadAll = $false                 # Upload all ADF files in docs/adf/ directory
)

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
# Function to upload a single ADF file
function Upload-SingleAdfFile {
    param (
        [string]$adfFilePath
    )
    
    # Extract the filename without extension to use as the page title
    $fileName = [System.IO.Path]::GetFileNameWithoutExtension($adfFilePath)
    $fileName = $fileName -replace "\.adf$", ""  # Remove .adf if present
    
    # Get the page title (use filename by default)
    $title = $fileName
    
    Write-Host "Uploading to Confluence: $title..." -ForegroundColor Cyan
    $response = Upload-ToConfluence $title $adfFilePath
    
    # Display result
    Write-Host "Successfully created Confluence page!" -ForegroundColor Green
    Write-Host "Title: $($response.title)" -ForegroundColor White
    Write-Host "ID: $($response.id)" -ForegroundColor White
    Write-Host "URL: $confluenceUrl/wiki$($response._links.webui)" -ForegroundColor White
    
    return $response
}

# Main script
Write-Host "Confluence ADF Uploader" -ForegroundColor Cyan
Write-Host "======================" -ForegroundColor Cyan

# Check if configuration is set
if ($apiToken -eq "your-api-token" -or $email -eq "your-email@example.com") {
    Write-Host "Please provide your Confluence URL, email, API token, and space key." -ForegroundColor Yellow
    
    # Prompt for credentials if not provided
    if ($confluenceUrl -eq "https://blueshieldca.atlassian.net") {
        $confluenceUrl = Read-Host "Enter your Confluence URL (e.g., https://your-domain.atlassian.net)"
    }
    
    if ($email -eq "your-email@example.com") {
        $email = Read-Host "Enter your Atlassian account email"
    }
    
    if ($apiToken -eq "your-api-token") {
        $apiToken = Read-Host "Enter your Atlassian API token"
    }
    
    if ($spaceKey -eq "SPACE") {
        $spaceKey = Read-Host "Enter your Confluence space key"
    }
    
    # Optional parent ID
    if ($parentId -eq "") {
        $parentIdInput = Read-Host "Enter parent page ID (optional, press Enter to skip)"
        if ($parentIdInput) {
            $parentId = $parentIdInput
        }
    }
}

# Handle different upload modes
if ($uploadAll) {
    # Upload all ADF files in docs/adf/ directory
    $adfFiles = Get-ChildItem -Path "docs/adf" -Filter "*.adf.json"
    
    if ($adfFiles.Count -eq 0) {
        Write-Host "No ADF files found in docs/adf/ directory." -ForegroundColor Yellow
        exit 1
    }
    
    Write-Host "Found $($adfFiles.Count) ADF files to upload." -ForegroundColor Cyan
    
    foreach ($file in $adfFiles) {
        Write-Host "`nProcessing file: $($file.FullName)" -ForegroundColor Cyan
        Upload-SingleAdfFile -adfFilePath $file.FullName
    }
    
    Write-Host "`nAll files uploaded successfully!" -ForegroundColor Green
} else {
    # Upload a single file
    if (-not $adfPath) {
        # If no specific ADF file was provided, ask for a Markdown file to convert
        $markdownPath = Read-Host "Enter the path to the Markdown file to upload (or enter an ADF file path ending with .adf.json)"
        
        if (-not (Test-Path $markdownPath)) {
            Write-Host "File not found: $markdownPath" -ForegroundColor Red
            exit 1
        }
        
        if ($markdownPath -like "*.adf.json") {
            # User provided an ADF file directly
            $adfPath = $markdownPath
            $title = Read-Host "Enter the title for the Confluence page"
            
            # Upload to Confluence
            Write-Host "Uploading to Confluence..." -ForegroundColor Cyan
            $response = Upload-ToConfluence $title $adfPath
            
            # Display result
            Write-Host "Successfully created Confluence page!" -ForegroundColor Green
            Write-Host "Title: $($response.title)" -ForegroundColor White
            Write-Host "ID: $($response.id)" -ForegroundColor White
            Write-Host "URL: $confluenceUrl/wiki$($response._links.webui)" -ForegroundColor White
        } else {
            # Convert Markdown to ADF
            $title = Read-Host "Enter the title for the Confluence page"
            
            Write-Host "Converting Markdown to ADF..." -ForegroundColor Cyan
            $adfPath = Convert-MarkdownToAdf $markdownPath
            Write-Host "Converted to ADF: $adfPath" -ForegroundColor Green
            
            # Upload to Confluence
            Write-Host "Uploading to Confluence..." -ForegroundColor Cyan
            $response = Upload-ToConfluence $title $adfPath
            
            # Display result
            Write-Host "Successfully created Confluence page!" -ForegroundColor Green
            Write-Host "Title: $($response.title)" -ForegroundColor White
            Write-Host "ID: $($response.id)" -ForegroundColor White
            Write-Host "URL: $confluenceUrl/wiki$($response._links.webui)" -ForegroundColor White
        }
    } else {
        # Use the provided ADF file path
        if (-not (Test-Path $adfPath)) {
            Write-Host "File not found: $adfPath" -ForegroundColor Red
            exit 1
        }
        
        Upload-SingleAdfFile -adfFilePath $adfPath
    }
}
Write-Host "URL: $confluenceUrl/wiki$($response._links.webui)" -ForegroundColor White