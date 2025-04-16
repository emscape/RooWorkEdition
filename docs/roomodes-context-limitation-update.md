# RooModes Context Limitation Update

## Summary of Changes

The context limitation rules that were recently implemented need to be applied to all custom modes defined in the `.roomodes` file. This document outlines the necessary changes to ensure consistent context management across all modes.

## Business Impact

Applying the context limitation rules to all custom modes in `.roomodes` will:

- Ensure system stability across all modes by preventing context overflow
- Provide a consistent user experience regardless of which mode is being used
- Reduce the risk of task failures due to exceeding token limits
- Maintain operational efficiency by proactively managing context size

## Required Changes

The following changes need to be made to the `.roomodes` file:

1. For each custom mode in the `.roomodes` file, update the `customInstructions` field to include the context limitation rule:

```
NEVER let context exceed 100k tokens. Monitor the context size in environment_details and prompt user to start a new task when context size approaches 80-90k tokens or when token cost nears $0.5
```

2. This rule should be added to the following modes:
   - qa-engineer
   - product-manager
   - uiux-designer
   - technical-writer
   - devops-engineer
   - security-engineer
   - data-scientist
   - boomerang-mode

## Implementation Details

### Current State

Currently, the custom modes in `.roomodes` have mode-specific instructions but do not include the context limitation rule. For example, the qa-engineer mode has:

```json
"customInstructions": "When testing software:\n1. Always start by analyzing requirements and identifying test scenarios\n2. Focus on edge cases and boundary conditions\n3. Document all test cases with clear steps and expected results\n4. Maintain detailed bug reports with reproduction steps\n5. Verify fixes through regression testing\n6. Consider performance, security, and accessibility implications\n7. Use appropriate testing tools and frameworks for the task\n8. Follow test-driven development practices when applicable"
```

### Required Updates

Each mode's `customInstructions` should be updated to include the context limitation rule. For example, the qa-engineer mode should be updated to:

```json
"customInstructions": "When testing software:\n1. Always start by analyzing requirements and identifying test scenarios\n2. Focus on edge cases and boundary conditions\n3. Document all test cases with clear steps and expected results\n4. Maintain detailed bug reports with reproduction steps\n5. Verify fixes through regression testing\n6. Consider performance, security, and accessibility implications\n7. Use appropriate testing tools and frameworks for the task\n8. Follow test-driven development practices when applicable\n\nNEVER let context exceed 100k tokens. Monitor the context size in environment_details and prompt user to start a new task when context size approaches 80-90k tokens or when token cost nears $0.5"
```

### Implementation Steps

1. Make a backup of the current `.roomodes` file
2. Edit the `.roomodes` file to add the context limitation rule to each mode's `customInstructions`
3. Validate the JSON syntax after making changes
4. Run the `sync-roomodes.ps1` script to propagate the changes to all repositories

## Technical Notes

- The `.roomodes` file is in JSON format but doesn't have a `.json` extension
- The file is synchronized across repositories using the `sync-roomodes.ps1` script
- The context limitation rule has already been added to the default system prompt and the modes in `cline_custom_modes.json`
- This update ensures consistency across all modes, both default and custom

## Verification

After implementing these changes, verify that:

1. The `.roomodes` file still contains valid JSON
2. All custom modes have the context limitation rule in their `customInstructions`
3. The `sync-roomodes.ps1` script successfully synchronizes the updated file to all repositories