# Validate Markdown files against HIT documentation template style
# This script checks if Markdown files follow the HIT documentation template style

# Configuration
$docsDir = "./docs"
$templateFile = "./docs/documentation-template.md"
$styleGuideFile = "./docs/documentation-style-guide.md"

# Check if template and style guide exist
if (-not (Test-Path $templateFile)) {
    Write-Host "Error: Template file not found at $templateFile" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $styleGuideFile)) {
    Write-Host "Error: Style guide file not found at $styleGuideFile" -ForegroundColor Red
    exit 1
}

# Function to validate a Markdown file against the HIT template style
function Validate-HitTemplate {
    param (
        [string]$filePath
    )

    Write-Host "Validating $filePath..." -ForegroundColor Cyan
    $content = Get-Content -Path $filePath -Raw
    $lines = Get-Content -Path $filePath
    $fileName = Split-Path -Path $filePath -Leaf
    $issues = @()

    # Check for required sections
    $hasOverview = $content -match "## Overview" -or $content -match "### Overview"
    $hasTableOfContents = $content -match "## Table of Contents" -or $content -match "### Table of Contents"
    $hasObjectives = $content -match "## Learning Objectives" -or $content -match "### Learning Objectives" -or
                     $content -match "## Expected Outcomes" -or $content -match "### Expected Outcomes" -or
                     $content -match "## Objectives" -or $content -match "### Objectives"
    $hasPrerequisites = $content -match "## Prerequisites" -or $content -match "### Prerequisites"

    # Check if sections have content
    $overviewHasContent = $false
    $objectivesHasContent = $false
    $prerequisitesHasContent = $false

    $inOverview = $false
    $inObjectives = $false
    $inPrerequisites = $false
    $emptyLineCount = 0

    for ($i = 0; $i -lt $lines.Count; $i++) {
        $line = $lines[$i].Trim()
        
        # Check for section headers
        if ($line -match "^#{2,3}\s+Overview") {
            $inOverview = $true
            $inObjectives = $false
            $inPrerequisites = $false
            $emptyLineCount = 0
            continue
        }
        elseif ($line -match "^#{2,3}\s+(Learning Objectives|Expected Outcomes|Objectives)") {
            $inOverview = $false
            $inObjectives = $true
            $inPrerequisites = $false
            $emptyLineCount = 0
            continue
        }
        elseif ($line -match "^#{2,3}\s+Prerequisites") {
            $inOverview = $false
            $inObjectives = $false
            $inPrerequisites = $true
            $emptyLineCount = 0
            continue
        }
        elseif ($line -match "^#{1,3}\s+") {
            $inOverview = $false
            $inObjectives = $false
            $inPrerequisites = $false
            continue
        }
        
        # Check if section has content
        if ($inOverview -and $line -ne "") {
            $overviewHasContent = $true
        }
        elseif ($inObjectives -and $line -ne "") {
            $objectivesHasContent = $true
        }
        elseif ($inPrerequisites -and $line -ne "") {
            $prerequisitesHasContent = $true
        }
    }

    # Add issues for missing sections or empty sections
    if (-not $hasOverview) {
        $issues += "Missing 'Overview' section (## Overview or ### Overview)"
    }
    elseif ($hasOverview -and -not $overviewHasContent) {
        $issues += "The 'Overview' section is empty"
    }

    if (-not $hasObjectives) {
        $issues += "Missing 'Learning Objectives/Expected Outcomes' section"
    }
    elseif ($hasObjectives -and -not $objectivesHasContent) {
        $issues += "The 'Learning Objectives/Expected Outcomes' section is empty"
    }

    if (-not $hasPrerequisites) {
        $issues += "Missing 'Prerequisites' section (## Prerequisites or ### Prerequisites)"
    }
    elseif ($hasPrerequisites -and -not $prerequisitesHasContent) {
        $issues += "The 'Prerequisites' section is empty"
    }

    # Table of Contents is optional but recommended
    if (-not $hasTableOfContents) {
        $issues += "Recommended: Add a 'Table of Contents' section for longer documents"
    }

    # Output validation results
    if ($issues.Count -eq 0) {
        Write-Host "✅ $fileName follows the HIT template style." -ForegroundColor Green
    } else {
        Write-Host "❌ $fileName has the following issues:" -ForegroundColor Yellow
        foreach ($issue in $issues) {
            Write-Host "   - $issue" -ForegroundColor Yellow
        }
        Write-Host "   Please refer to the template and style guide for guidance:" -ForegroundColor Yellow
        Write-Host "   - $templateFile" -ForegroundColor Yellow
        Write-Host "   - $styleGuideFile" -ForegroundColor Yellow
    }

    return $issues.Count -eq 0
}

# Get all Markdown files in the docs directory (excluding the template and style guide)
$markdownFiles = Get-ChildItem -Path $docsDir -Filter "*.md" -Recurse | 
                 Where-Object { $_.FullName -ne $templateFile -and $_.FullName -ne $styleGuideFile -and $_.FullName -notlike "*\excluded\*" }

# Validate each Markdown file
$validCount = 0
$totalCount = $markdownFiles.Count

foreach ($file in $markdownFiles) {
    $isValid = Validate-HitTemplate -filePath $file.FullName
    if ($isValid) {
        $validCount++
    }
    Write-Host ""
}

# Summary
Write-Host "Validation Summary:" -ForegroundColor Cyan
Write-Host "$validCount out of $totalCount files follow the HIT template style." -ForegroundColor Cyan
if ($validCount -ne $totalCount) {
    Write-Host "Please update the non-compliant files to follow the HIT template style." -ForegroundColor Yellow
    Write-Host "Refer to the template and style guide for guidance:" -ForegroundColor Yellow
    Write-Host "- $templateFile" -ForegroundColor Yellow
    Write-Host "- $styleGuideFile" -ForegroundColor Yellow
}