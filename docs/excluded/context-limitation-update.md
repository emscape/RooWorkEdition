# Context Limitation Update

## Summary of Changes

The default Roo instructions for all modes have been updated to include a strict context limitation of 100k tokens. This change was implemented in two key locations:

1. Added a new rule in the default system prompt (`default-system-prompt.md`) in the RULES section
2. Updated the custom instructions for all modes in `roo_package/config/.roo/default-mode/cline_custom_modes.json`

## Business Impact

This update addresses a critical system stability issue where tasks would fail to load when context size exceeded 100k tokens. By implementing proactive context management:

- System reliability is improved
- Task continuity is maintained
- User experience is enhanced by preventing unexpected failures
- Operational efficiency is increased by reducing support incidents related to context overflows

## Usage Examples

### For Users

When using Roo, you'll now receive proactive notifications when context size approaches the limit:

```
[CONTEXT WARNING] Current context size is approaching the 100k token limit (currently at 85k tokens).
I recommend saving your work and starting a new task to prevent system failure.
```

This warning mechanism is triggered automatically when:
- The context size reaches approximately 80-90k tokens (visible in the environment_details)
- The token cost approaches $0.50

Both Roo and the user will be prompted to:
1. Wrap up the current work
2. Save important context to memory bank (if available)
3. Begin a new task to continue the work

The warning will appear directly in Roo's response, making it visible to users without requiring them to check environment details. This proactive approach ensures users are aware of potential issues before they occur.

When this warning appears, you should:

1. Complete your current subtask if possible
2. Use the memory bank to save important context (if available)
3. Start a new task to continue your work

### For Developers

The context limitation is now enforced through multiple layers:

```json
"customInstructions": "Always check to make sure memory bank is active. Explicitly prompt Emily when she needs to do a manual action. terminal commands must be PowerShell. Explicitly prompt Emily when she needs to do a manual action. NEVER let context exceed 100k tokens. Monitor the context size in environment_details and prompt user to start a new task when context size approaches 80-90k tokens or when token cost nears $0.5"
```

This ensures that all modes will proactively monitor context size and take appropriate action before reaching critical limits.

## Technical Details

### Implementation Details

The context limitation was implemented in two key locations:

1. **System Prompt Rule**: Added to `default-system-prompt.md` around line 1736:
   ```
   - Context size must NEVER exceed 100k tokens. If you notice the context size approaching this limit (around 80-90k tokens), you must inform the user and recommend starting a new task. This is critical to prevent system failures where context won't load at all.
   ```

2. **Mode-Specific Instructions**: Updated in `cline_custom_modes.json` for all modes:
   ```
   NEVER let context exceed 100k tokens. Monitor the context size in environment_details and prompt user to start a new task when context size approaches 80-90k tokens or when token cost nears $0.5
   ```

### How It Works

The system now:

1. Continuously monitors context size through the `environment_details` section
2. Proactively warns users when context approaches 80-90k tokens
3. Displays a clear warning message in Roo's response
4. Recommends specific actions for both Roo and the user to take
5. Suggests starting a new task before reaching the critical 100k limit
6. Prevents system failures by ensuring context remains manageable

The warning mechanism is implemented through two key components:

1. **System-level monitoring**: The default system prompt instructs Roo to monitor context size and issue warnings
2. **Mode-specific instructions**: Each mode has custom instructions to check context size and take appropriate action

This dual-layer approach ensures that regardless of which mode is active, context size will be monitored and warnings will be issued when necessary.

### Why This Matters

Large language models like Claude have context window limitations. When context exceeds these limits, the system may fail to load or process the information correctly. By implementing proactive context management, we ensure the system remains stable and responsive, providing a better user experience.