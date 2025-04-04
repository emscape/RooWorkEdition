# RooFlow Setup Package

This package contains the necessary scripts and tools to perform a comprehensive setup of RooFlow features (including custom modes, Memory Bank, and ADF integration) in either a new or existing project.

## Purpose

The goal is to provide a self-contained distribution for initializing a project with:
- Roo custom modes (via `.roomodes`).
- The Roo Memory Bank system.
- Default MCP server configurations.
- An Atlassian Document Format (ADF) documentation workflow and tools.
- Necessary configuration files like `.rooignore` and `.gitignore`.

## Contents

- `scripts/`: Contains the setup scripts:
    - `apply-to-existing-project.ps1`: Use this to add RooFlow features to the current project.
    - `setup-new-project.ps1`: Use this to initialize the current directory with RooFlow features.
- `tools/adf/`: Contains the necessary tools for the ADF documentation workflow (viewer, converter, etc.).

## How to Use

1.  **Place the Package:** Copy the contents of this `roo_package` directory into your project directory.

2.  **Choose the Right Script:**
    *   **For an existing project:** Use `apply-to-existing-project.ps1`.
    *   **For a new project:** Use `setup-new-project.ps1`.

3.  **Run the Script:** Open PowerShell, navigate to your project directory, and execute the chosen script.

    **Example: Applying to an Existing Project**
    Navigate to your project directory and run:
    ```powershell
    .\apply-to-existing-project.ps1
    ```

    **Example: Setting up a New Project**
    Navigate to your project directory and run:
    ```powershell
    .\setup-new-project.ps1
    ```
    
    The script will automatically use your current directory name as the project name. If you want to specify a different name, you can use:
    ```powershell
    .\setup-new-project.ps1 -ProjectName "CustomProjectName"
    ```

4.  **Follow Script Prompts:** The scripts will output progress and may provide next steps upon completion.

5.  **Verify:** Check the target project directory for the newly created files and folders (`.roo`, `.roomodes`, `memory-bank`, `docs/adf`, `tools/adf`, etc.).

Now RooFlow should be fully configured for your project!