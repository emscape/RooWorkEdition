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
    - `apply-to-existing-project.ps1`: Use this to add RooFlow features to an existing project.
    - `setup-new-project.ps1`: Use this to create a new project directory and initialize it with RooFlow features.
- `tools/adf/`: Contains the necessary tools for the ADF documentation workflow (viewer, converter, etc.).

## How to Use

1.  **Place the Package:** Store this `roo_package` directory in a convenient, accessible location (e.g., `C:\RooTools\roo_package`).

2.  **Choose the Right Script:**
    *   **For an existing project:** Use `apply-to-existing-project.ps1`.
    *   **For a new project:** Use `setup-new-project.ps1`.

3.  **Run the Script:** Open PowerShell and execute the chosen script, providing the necessary parameters.

    **Example: Applying to an Existing Project**
    Navigate *outside* the package directory. Run the script, pointing to its location within the package and specifying the target project path.
    ```powershell
    # Assuming roo_package is in C:\RooTools
    C:\RooTools\roo_package\scripts\apply-to-existing-project.ps1 -ProjectPath "C:\path\to\your\existing\project"
    ```

    **Example: Setting up a New Project**
    Navigate *outside* the package directory. Run the script, pointing to its location within the package and specifying the new project name and the parent directory where it should be created.
    ```powershell
    # Assuming roo_package is in C:\RooTools
    # This will create C:\path\to\parent\directory\MyNewProject
    C:\RooTools\roo_package\scripts\setup-new-project.ps1 -ProjectName "MyNewProject" -ProjectPath "C:\path\to\parent\directory"
    ```

4.  **Follow Script Prompts:** The scripts will output progress and may provide next steps upon completion.

5.  **Verify:** Check the target project directory for the newly created files and folders (`.roo`, `.roomodes`, `memory-bank`, `docs/adf`, `tools/adf`, etc.).

Now RooFlow should be fully configured for your project!