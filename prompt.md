# Role & Objective
You are an expert Python developer and DevOps engineer. Your task is to initialize a static personal knowledge base and note-taking website for a Computer Science student. 
The project must be built using `mkdocs` with the `mkdocs-material` theme, and configured for automated deployment via GitHub Actions.

# Tech Stack
- Python
- MkDocs
- Material for MkDocs (mkdocs-material)
- GitHub Actions (for CI/CD)

# Execution Steps

## Step 1: Environment & Project Initialization
1. Create a `requirements.txt` file containing exactly this line: `mkdocs-material`.
2. Initialize the standard MkDocs project structure in the current directory (do not run `mkdocs new`, just create the files directly to avoid overriding):
   - `/docs` folder
   - `mkdocs.yml`

## Step 2: Configure mkdocs.yml
Populate `mkdocs.yml` with the following optimal configurations for CS/programming notes:
- site_name: "My Knowledge Base"
- theme: 
    name: material
    features:
      - navigation.tabs
      - navigation.sections
      - navigation.top
      - search.suggest
      - search.highlight
- markdown_extensions:
    - pymdownx.highlight:
        anchor_linenums: true
    - pymdownx.inlinehilite
    - pymdownx.snippets
    - pymdownx.superfences
    - pymdownx.arithmatex:
        generic: true
    - pymdownx.tasklist:
        custom_checkbox: true

## Step 3: Scaffold Directory Structure
Create a practical folder structure inside `/docs` for a CS major. Create a placeholder `README.md` file in each folder:
- `/docs/01-Data-Structures/`
- `/docs/02-C-and-Cpp/`
- `/docs/03-Python-Blue-Bridge-Cup/`
- `/docs/04-Projects/`

## Step 4: Write Sample Notes
1. Create `/docs/index.md` with a brief welcome page.
2. Create a fun sample note in `/docs/03-Python-Blue-Bridge-Cup/test.md` about "Python agent for feeding yljcat and txrcat" just to test Python code block highlighting.

## Step 5: GitHub Actions Setup for Deployment
1. Create the directory `.github/workflows/`.
2. Create a file named `ci.yml` inside it.
3. Write the standard GitHub Actions workflow to deploy MkDocs Material to GitHub Pages. It should trigger on `push` to the `main` or `master` branch. Ensure it grants `permissions: contents: write` to allow the deployment to the `gh-pages` branch.

## Step 6: Git Configuration
Create a `.gitignore` file suitable for a Python/MkDocs project. Explicitly ignore:
- `site/`
- `.venv/`
- `__pycache__/`
- `.DS_Store` (crucial for macOS)

# Constraints
- Do not wait for further user input. Execute the file creation, directory scaffolding, and code writing immediately.
- Ensure all paths are relative and cross-platform friendly (the workspace will be synced across macOS and Windows).