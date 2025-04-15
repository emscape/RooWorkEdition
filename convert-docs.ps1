# Convert Markdown docs to ADF
# This script converts all Markdown files in the docs directory to ADF format
# It also validates if the Markdown files follow the HIT documentation template style

# Configuration
$docsDir = "./docs"
$adfDocsDir = "./docs/adf"
$toolsDir = "./tools/adf"
$templateFile = "./docs/documentation-template.md"
$styleGuideFile = "./docs/documentation-style-guide.md"
$validateScript = "./validate-hit-template.ps1"

# Create directories if they don't exist
if (-not (Test-Path $adfDocsDir)) {
    New-Item -ItemType Directory -Path $adfDocsDir -Force | Out-Null
    Write-Host "Created $adfDocsDir" -ForegroundColor Green
}

if (-not (Test-Path $toolsDir)) {
    New-Item -ItemType Directory -Path $toolsDir -Force | Out-Null
    Write-Host "Created $toolsDir" -ForegroundColor Green
    
    # Copy ADF tools to tools directory
    $toolFiles = @(
        "adf-viewer.html",
        "markdown-to-adf.html",
        "markdown-to-adf.js",
        "adf-documentation.json",
        "example-adf.json"
    )
    
    foreach ($file in $toolFiles) {
        if (Test-Path $file) {
            Copy-Item -Path $file -Destination "$toolsDir/" -Force
            Write-Host "Copied $file to $toolsDir/" -ForegroundColor Green
        } else {
            Write-Host "Warning: $file not found in current directory" -ForegroundColor Yellow
        }
    }
}

# Check if template and style guide exist
$templateExists = Test-Path $templateFile
$styleGuideExists = Test-Path $styleGuideFile
$validateScriptExists = Test-Path $validateScript

# Validate Markdown files against HIT template style if possible
$validationEnabled = $templateExists -and $styleGuideExists -and $validateScriptExists
if ($validationEnabled) {
    Write-Host "Validating Markdown files against HIT template style..." -ForegroundColor Cyan
    & $validateScript
    
    Write-Host "`nDo you want to continue with conversion even if some files don't follow the HIT template style? (Y/N)" -ForegroundColor Yellow
    $response = Read-Host
    if ($response -ne "Y" -and $response -ne "y") {
        Write-Host "Conversion cancelled. Please update the files to follow the HIT template style." -ForegroundColor Red
        exit
    }
} else {
    Write-Host "Skipping validation: Template, style guide, or validation script not found." -ForegroundColor Yellow
    if (-not $templateExists) {
        Write-Host "  - Template file not found at $templateFile" -ForegroundColor Yellow
    }
    if (-not $styleGuideExists) {
        Write-Host "  - Style guide file not found at $styleGuideFile" -ForegroundColor Yellow
    }
    if (-not $validateScriptExists) {
        Write-Host "  - Validation script not found at $validateScript" -ForegroundColor Yellow
    }
}

# Convert Markdown files to ADF
Write-Host "`nConverting Markdown files to ADF..." -ForegroundColor Cyan

$markdownFiles = Get-ChildItem -Path $docsDir -Filter "*.md" -Recurse | Where-Object {
    $_.FullName -notlike "*$adfDocsDir*" -and
    $_.FullName -ne $templateFile -and
    $_.FullName -ne $styleGuideFile
}

foreach ($file in $markdownFiles) {
    $relativePath = $file.FullName.Substring((Resolve-Path $docsDir).Path.Length + 1)
    $outputPath = Join-Path -Path $adfDocsDir -ChildPath ($relativePath -replace "\.md$", ".adf.json")
    
    # Create directory if it doesn't exist
    $outputDir = Split-Path -Path $outputPath -Parent
    if (-not (Test-Path $outputDir)) {
        New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
    }
    
    # Convert Markdown to ADF
    Write-Host "Converting $($file.FullName) to $outputPath" -ForegroundColor Green
    node "$toolsDir/markdown-to-adf.js" $file.FullName $outputPath
}

Write-Host "`nConversion complete!" -ForegroundColor Cyan
Write-Host "You can view the converted ADF files using the ADF viewer:" -ForegroundColor Cyan
Write-Host "Start-Process `"$toolsDir/adf-viewer.html`"" -ForegroundColor Green

if ($validationEnabled) {
    Write-Host "`nReminder: Some files may not follow the HIT template style." -ForegroundColor Yellow
    Write-Host "Please refer to the template and style guide for guidance:" -ForegroundColor Yellow
    Write-Host "- $templateFile" -ForegroundColor Yellow
    Write-Host "- $styleGuideFile" -ForegroundColor Yellow
}