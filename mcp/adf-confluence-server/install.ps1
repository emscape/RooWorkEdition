# Install dependencies for the Confluence MCP server
Write-Host "Installing dependencies for the Confluence MCP server..." -ForegroundColor Cyan

# Check if Node.js is installed
try {
    $nodeVersion = node -v
    Write-Host "Node.js version: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "Node.js is not installed. Please install Node.js before continuing." -ForegroundColor Red
    Write-Host "You can download Node.js from https://nodejs.org/" -ForegroundColor Yellow
    exit 1
}

# Check if npm is installed
try {
    $npmVersion = npm -v
    Write-Host "npm version: $npmVersion" -ForegroundColor Green
} catch {
    Write-Host "npm is not installed. Please install npm before continuing." -ForegroundColor Red
    exit 1
}

# Install dependencies
Write-Host "Installing npm dependencies..." -ForegroundColor Cyan
npm install

# Build the TypeScript code
Write-Host "Building TypeScript code..." -ForegroundColor Cyan
npm run build

# Create .env file if it doesn't exist
if (-not (Test-Path -Path ".env")) {
    Write-Host "Creating .env file from template..." -ForegroundColor Cyan
    Copy-Item -Path ".env.template" -Destination ".env"
    Write-Host "Created .env file. Please edit it to add your Confluence credentials." -ForegroundColor Yellow
} else {
    Write-Host ".env file already exists" -ForegroundColor Yellow
}

Write-Host "`nInstallation complete!" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor White
Write-Host "1. Edit the .env file to add your Confluence credentials" -ForegroundColor White
Write-Host "2. Run the server with 'npm start'" -ForegroundColor White
Write-Host "3. Configure the MCP server in Roo with 'scripts\Configure-McpServers.ps1'" -ForegroundColor White