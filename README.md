# Weaviate 1.31 Enablement session

## Key features

- Shard movement between nodes
- MUVERA encoding algorithm for multi-vector embeddings
- Vectorizer changes
- HNSW snapshotting

## How to run

Option 1: Devcontainer
Option 2: Github Codespaces

### Option 1: Devcontainer

1. Install Docker
2. Install VSCode
3. Install Devcontainer extension
4. Open this repository in VSCode
5. Open the command palette (Ctrl/Cmd+Shift+P), and select "Dev Containers: Rebuild and Reopen in Container"
6. Wait for the container to build and start

### Option 2: Github Codespaces

1. Click on the green "Code" button in the top right corner of the repository
2. Select "Open with Codespaces"
3. Click on "New codespace"
4. Wait for the codespace to build and start

## How to run this demo

1. Open a terminal (in the devcontainer or codespace)
2. Run the following command to start Weaviate:
   ```bash
   ./run-weaviate.sh start
   ```
3. Wait for Weaviate to start (it will show a message on the terminal when finished)
4. Create a `.env` file in the root of the repository with the required key and value pairs:
   ```env
   COHERE_API_KEY=your_core_api_key
   ```
5. Open the notebook, `enablement.ipynb`, in VSCode, and select the kernel using the virtual environment (`./.venv/bin/python`).
6. Run the notebook cells in order to see the demo in action.
