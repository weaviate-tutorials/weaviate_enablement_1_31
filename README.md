Note - this repository is archived.

Please see https://github.com/weaviate-tutorials/weaviate-enablement-sessions for future sessions

# Weaviate 1.31 Enablement session

## Key features

- Shard movement between nodes
- MUVERA encoding algorithm for multi-vector embeddings
- Vectorizer changes
- HNSW snapshotting

## How to run this demo

1. Open a terminal (in the local env)
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
