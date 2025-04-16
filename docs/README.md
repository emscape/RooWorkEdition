# RooFlow Custom Modes and Memory Bank

## Introduction

### Overview
This documentation repository provides comprehensive guidance on implementing and utilizing RooFlow custom modes and memory bank functionality in your projects. RooFlow enhances Roo Code's capabilities by adding persistent memory storage, structured mode collaboration, and specialized behavior for different development tasks. This documentation serves as the central reference for understanding, implementing, and optimizing the RooFlow system.

### Learning Objectives/Expected Outcomes
* Understand the core concepts of RooFlow custom modes and memory bank functionality
* Learn how to implement RooFlow in both existing and new projects
* Master the structure and purpose of each memory bank component
* Effectively use mode collaboration for different development tasks
* Apply best practices for maintaining and updating the memory bank

## Table of Contents
- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [What is RooFlow?](#what-is-rooflow)
- [Documentation](#documentation)
- [Memory Bank Structure](#memory-bank-structure)
- [Global vs. Project-Specific Modes](#global-vs-project-specific-modes)
- [Memory Bank Commands](#memory-bank-commands)
- [Getting Started](#getting-started)
- [Best Practices](#best-practices)

## Prerequisites
* Basic understanding of Roo Code and its capabilities
* Familiarity with version control systems (Git recommended)
* Access to the RooFlow package files
* Administrative access to modify project configuration files

## What is RooFlow?

RooFlow is a set of custom modes for Roo Code that enhances its capabilities with:

1. **Memory Bank Functionality**: Persistent context storage across sessions
2. **Mode Collaboration**: Structured handoffs between different Roo modes
3. **Custom Instructions**: Specialized behavior for each mode

## Documentation

- [Applying to Existing Projects](applying-to-existing-projects.md): How to add RooFlow to projects that are already set up
- [Applying to Future Projects](applying-to-future-projects.md): How to start new projects with RooFlow from the beginning

## Memory Bank Structure

The memory bank consists of five key files:

1. **productContext.md**: High-level project description, goals, features, and architecture
2. **activeContext.md**: Current focus, recent changes, and open questions/issues
3. **systemPatterns.md**: Design patterns, architectural patterns, and coding standards
4. **decisionLog.md**: Record of significant architectural decisions
5. **progress.md**: Timeline of project progress and milestones

## Global vs. Project-Specific Modes

RooFlow supports two types of custom modes:

1. **Global Modes**: Applied to all projects (stored in `cline_custom_modes.json`)
2. **Project-Specific Modes**: Applied only to the current project (stored in `.roomodes`)

## Memory Bank Commands

- **Check Memory Bank Status**: Roo will indicate if the memory bank is active or inactive at the beginning of each response
- **Update Memory Bank (UMB)**: Use this command to manually trigger a comprehensive update of the memory bank

## Getting Started

1. Choose the appropriate guide based on your scenario:
   - For existing projects: [Applying to Existing Projects](applying-to-existing-projects.md)
   - For new projects: [Applying to Future Projects](applying-to-future-projects.md)

2. Follow the step-by-step instructions to set up the memory bank and custom modes

3. Start using Roo Code with enhanced memory bank functionality

## Best Practices

1. **Regular Updates**: Use the "Update Memory Bank" command at key milestones
2. **Consistent Structure**: Follow the established format for each memory bank file
3. **Mode Selection**: Use the appropriate mode for each task:
   - Architect mode for planning and design
   - Code mode for implementation
   - Debug mode for troubleshooting
   - Ask mode for questions and information
   - Test mode for testing strategies
4. **Version Control**: Include memory bank files in version control for team collaboration