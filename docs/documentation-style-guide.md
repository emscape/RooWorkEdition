# Documentation Style Guide

## Introduction

### Overview
This guide provides instructions on how to write documentation following the HIT documentation template style. It explains the structure, formatting, and best practices for creating consistent, high-quality documentation across the RooFlow project.

### Learning Objectives/Expected Outcomes
* Understand the HIT documentation template structure
* Learn how to format documentation according to the template
* Know how to convert existing documentation to follow the template
* Be able to create new documentation that adheres to the style guide

## Prerequisites
* Basic knowledge of Markdown syntax
* Access to the project repository
* Familiarity with the project's documentation needs

## Understanding the HIT Documentation Template

### Template Structure
The HIT documentation template follows a specific structure designed to make documentation clear, consistent, and easy to navigate. The basic structure includes:

1. **Title**: The main title of the document (h1)
2. **Introduction**: 
   - Overview: Brief summary of the document's purpose
   - Learning Objectives/Expected Outcomes: What the reader will gain
3. **Prerequisites**: Requirements before proceeding
4. **Step-by-Step Guide**: Main content organized by steps
5. **Troubleshooting/FAQs**: Common issues and solutions
6. **Additional Resources**: Related documentation and references

### Heading Hierarchy
Use the following heading hierarchy consistently:

* **h1 (#)**: Document title
* **h2 (##)**: Major sections (Introduction, Prerequisites, etc.)
* **h3 (###)**: Subsections or step titles
* **h4 (####)**: Sub-steps or detailed points

Example:
```markdown
# Document Title

## Introduction

### Overview
Content here...

### Learning Objectives
Content here...

## Step-by-Step Guide

### Step One: First Step
Content here...

#### Sub-step 1.1: Detail
Content here...
```

## Writing Guidelines

### General Principles
1. **Be clear and concise**: Use simple language and avoid unnecessary jargon
2. **Use active voice**: "Run the script" instead of "The script should be run"
3. **Be specific**: Provide exact commands, file paths, and expected outcomes
4. **Use examples**: Include examples to illustrate complex concepts
5. **Include visuals**: Add screenshots, diagrams, or code blocks where helpful

### Formatting Best Practices

#### Code Blocks
Use triple backticks with the language specified for code blocks:

```markdown
```powershell
.\convert-docs.ps1
```
```

#### Lists
* Use bullet points for unordered lists
* Use numbered lists for sequential steps
* Indent sub-items for hierarchy

#### Emphasis
* Use **bold** for emphasis and UI elements
* Use *italics* for introducing new terms
* Use `code formatting` for code, commands, and file paths

#### Notes and Warnings
Format important notes and warnings to stand out:

```markdown
> **Note:** This is an important note that users should pay attention to.

> **Warning:** This is a critical warning about potential issues.
```

## Converting Existing Documentation

### Step One: Analyze Current Structure
Review the existing document to identify its main sections, steps, and information hierarchy.

#### Sub-step 1.1: Identify Key Components
Identify the following components in the existing document:
* Main topic and purpose
* Steps or processes described
* Technical details and examples
* Troubleshooting information

### Step Two: Reorganize Content
Reorganize the content to follow the HIT template structure.

#### Sub-step 2.1: Create Introduction Section
* Write a concise overview
* List learning objectives or expected outcomes

#### Sub-step 2.2: Format Main Content
* Organize content into clear steps with h3 headings
* Break down complex steps into sub-steps with h4 headings
* Format code examples, commands, and file paths consistently

#### Sub-step 2.3: Add Troubleshooting Section
* Identify common issues from the existing content
* Format as a FAQ with clear issue descriptions and solutions

### Step Three: Review and Refine
Review the converted document for clarity, completeness, and adherence to the template.

## Example Conversion

### Before (Original Format)
```markdown
# Feature Implementation

This document explains how to implement the new feature.

## Setup
First, install the dependencies:
```bash
npm install
```

## Configuration
Edit the config.json file with your settings.

## Running
Start the application with:
```bash
npm start
```

If you encounter errors, check the logs.
```

### After (HIT Template Format)
```markdown
# Feature Implementation

## Introduction

### Overview
This document provides a step-by-step guide for implementing the new feature in the application. It covers installation, configuration, and execution.

### Learning Objectives/Expected Outcomes
* Successfully install all required dependencies
* Configure the application correctly
* Run the application with the new feature enabled

## Prerequisites
* Node.js installed on your system
* Access to the project repository

## Step-by-Step Implementation

### Step One: Install Dependencies
Install all required dependencies using npm.

```bash
npm install
```

### Step Two: Configure the Application
Edit the configuration file to enable and customize the new feature.

#### Sub-step 2.1: Locate Configuration File
Open the `config.json` file in your project root directory.

#### Sub-step 2.2: Update Settings
Update the following settings:
* `featureEnabled`: Set to `true`
* `featureOptions`: Configure according to your needs

### Step Three: Run the Application
Start the application to use the new feature.

```bash
npm start
```

## Troubleshooting/FAQs

### Application Fails to Start
If the application doesn't start properly, check the logs for specific error messages.

### Feature Not Working
Ensure that `featureEnabled` is set to `true` in the configuration file.

## Additional Resources
* [Node.js Documentation](https://nodejs.org/en/docs/)
* [Project Wiki](https://example.com/wiki)
```

## Conclusion
Following this style guide will ensure that all documentation in the RooFlow project is consistent, clear, and easy to use. The HIT documentation template provides a structured approach that helps readers find information quickly and understand complex topics more easily.