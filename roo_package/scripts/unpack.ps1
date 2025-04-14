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
    # Copy scripts directory
    $scriptsDir = Join-Path -Path $packageDir -ChildPath "scripts"
    $targetScriptsDir = Join-Path -Path $currentDir -ChildPath "scripts"
    
    if (-not (Test-Path -Path $targetScriptsDir)) {
        New-Item -Path $targetScriptsDir -ItemType Directory | Out-Null
    }
    
    Copy-Item -Path "$scriptsDir\*" -Destination $targetScriptsDir -Recurse -Force
    Write-Host "Copied scripts directory" -ForegroundColor Green
    
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
    
    Write-Host "RooFlow package unpacked successfully!" -ForegroundColor Green
    
    # Run the setup script
    Write-Host "Running setup script..." -ForegroundColor Cyan
    
    $setupScript = Join-Path -Path $currentDir -ChildPath "scripts\setup-new-project.ps1"
    
    if ($ProjectName -ne "") {
        & $setupScript -ProjectName $ProjectName
    } else {
        & $setupScript
    }
    
} catch {
    Write-Error "An error occurred while unpacking the RooFlow package: $_"
    exit 1
}