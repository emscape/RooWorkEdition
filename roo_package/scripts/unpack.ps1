# Unpack RooFlow Package
# This script unpacks the RooFlow package to the current directory and runs the setup script
# Usage: .\unpack.ps1 [-ProjectName "YourProjectName"]

param(
    [Parameter(Mandatory=$false)]
    [string]$ProjectName = ""
)

# Get the directory where this script is located
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$packageDir = Split-Path -Parent $scriptDir

# Get the current directory
$currentDir = Get-Location

Write-Host "Unpacking RooFlow package to the current directory..." -ForegroundColor Cyan

# Copy all files from the package to the current directory
try {
    # Scripts directory is now part of the package and not copied separately
    # Copy tools directory
    $toolsDir = Join-Path -Path $packageDir -ChildPath "tools"
    $targetToolsDir = Join-Path -Path $currentDir -ChildPath "tools"
    
    if (-not (Test-Path -Path $targetToolsDir)) {
        New-Item -Path $targetToolsDir -ItemType Directory | Out-Null
    }
    
    Copy-Item -Path "$toolsDir\*" -Destination $targetToolsDir -Recurse -Force
    Write-Host "Copied tools directory" -ForegroundColor Green
    
    # Copy config directory
    $configDir = Join-Path -Path $packageDir -ChildPath "config"
    $targetConfigDir = Join-Path -Path $currentDir -ChildPath "config"
    
    if (-not (Test-Path -Path $targetConfigDir)) {
        New-Item -Path $targetConfigDir -ItemType Directory | Out-Null
    }
    
    Copy-Item -Path "$configDir\*" -Destination $targetConfigDir -Recurse -Force
    Write-Host "Copied config directory" -ForegroundColor Green
    
    # Handle .roomodes file (merge if exists, otherwise copy)
    $packageRoomodesPath = Join-Path -Path $packageDir -ChildPath ".roomodes"
    $targetRoomodesPath = Join-Path -Path $currentDir -ChildPath ".roomodes"

    if (Test-Path -Path $packageRoomodesPath) {
        if (Test-Path -Path $targetRoomodesPath) {
            Write-Host "Merging existing .roomodes file with package version..." -ForegroundColor Yellow
            try {
                # Read and parse both files
                $packageJson = Get-Content -Path $packageRoomodesPath -Raw | ConvertFrom-Json
                $targetJson = Get-Content -Path $targetRoomodesPath -Raw | ConvertFrom-Json

                # Ensure customModes arrays exist
                if ($null -eq $packageJson.customModes) { $packageJson.customModes = @() }
                if ($null -eq $targetJson.customModes) { $targetJson.customModes = @() }

                # Get slugs from target modes
                $targetSlugs = $targetJson.customModes | ForEach-Object { $_.slug }

                # Add modes from package if slug doesn't exist in target
                foreach ($packageMode in $packageJson.customModes) {
                    if ($packageMode.slug -notin $targetSlugs) {
                        Write-Host "Adding mode '$($packageMode.slug)' from package." -ForegroundColor Cyan
                        $targetJson.customModes += $packageMode
                    } else {
                         Write-Host "Mode '$($packageMode.slug)' already exists in project, skipping." -ForegroundColor Gray
                    }
                }

                # Write merged content back
                $targetJson | ConvertTo-Json -Depth 10 | Set-Content -Path $targetRoomodesPath
                Write-Host "Successfully merged .roomodes file." -ForegroundColor Green
            } catch {
                Write-Error "Failed to merge .roomodes file: $_. Trying simple copy instead."
                Copy-Item -Path $packageRoomodesPath -Destination $targetRoomodesPath -Force
                Write-Host "Copied .roomodes file (merge failed)." -ForegroundColor Yellow
            }
        } else {
            # Target file doesn't exist, just copy
            Copy-Item -Path $packageRoomodesPath -Destination $targetRoomodesPath -Force
            Write-Host "Copied new .roomodes file from package." -ForegroundColor Green
        }
    } else {
        Write-Host "No .roomodes file found in package to copy or merge." -ForegroundColor Yellow
    }
    
    Write-Host "RooFlow package unpacked successfully!" -ForegroundColor Green

    # Determine if it's a new or existing project
    $items = Get-ChildItem -Path $currentDir -Exclude "roo_package"
    if ($items.Count -gt 0) {
        Write-Host "Existing project detected." -ForegroundColor Cyan
        $setupScript = Join-Path -Path $scriptDir -ChildPath "apply-to-existing-project.ps1"
    } else {
        Write-Host "New project detected." -ForegroundColor Cyan
        $setupScript = Join-Path -Path $scriptDir -ChildPath "setup-new-project.ps1"
    }

    # Run the appropriate setup script
    Write-Host "Running setup script..." -ForegroundColor Cyan
    if ($ProjectName -ne "") {
        & $setupScript -ProjectName $ProjectName
    } else {
        & $setupScript
    }

    # Initialize the Roo Memory System
    Write-Host "Initializing Roo Memory System..." -ForegroundColor Cyan
    $memorySystemScript = Join-Path -Path $scriptDir -ChildPath "Initialize-RooMemorySystem.ps1"
    & $memorySystemScript -ProjectPath $currentDir

    # Set up ADF Documentation Workflow
    Write-Host "Setting up ADF Documentation Workflow..." -ForegroundColor Cyan
    $adfWorkflowScript = Join-Path -Path $scriptDir -ChildPath "setup-adf-workflow.ps1"
    & $adfWorkflowScript

    # Suggest configuring MCP servers
    Write-Host "`nNext steps:" -ForegroundColor Cyan
    Write-Host "1. Configure MCP servers (optional): .\roo_package\scripts\Configure-McpServers.ps1" -ForegroundColor Cyan
    Write-Host "2. Start a new Roo Code task in Architect mode" -ForegroundColor Cyan
    Write-Host "3. Roo will detect the memory bank and activate it" -ForegroundColor Cyan
    
    # Prompt user to switch to Architect mode
    Write-Host "`nRooFlow setup complete! Please switch to Architect mode and ask a question to initialize the memory bank." -ForegroundColor Green
    
} catch {
    Write-Error "An error occurred while unpacking the RooFlow package: $_"
    exit 1
}