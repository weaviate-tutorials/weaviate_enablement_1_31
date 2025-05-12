#!/bin/bash

# Create the script directory if it doesn't exist
mkdir -p ~/.devcontainer/scripts

# Create a more robust setup script
cat > ~/.devcontainer/scripts/activate-venv.sh << 'EOF'
#!/bin/bash

# Find the virtual environment activation script
VENV_ACTIVATE=$(find ${WORKSPACE_FOLDER} -name activate -path "*/venv/bin/activate" 2>/dev/null | head -n 1)

# If not found, try a more general search
if [ -z "$VENV_ACTIVATE" ]; then
  VENV_ACTIVATE=$(find ${WORKSPACE_FOLDER} -name activate 2>/dev/null | head -n 1)
fi

# If found, source it
if [ -n "$VENV_ACTIVATE" ]; then
  if [ -z "$VIRTUAL_ENV" ] || [[ "$VIRTUAL_ENV" != *"${WORKSPACE_FOLDER}"* ]]; then
    echo "Activating virtual environment: $VENV_ACTIVATE"
    source "$VENV_ACTIVATE"
  fi
else
  echo "Warning: No virtual environment activation script found"
fi
EOF

# Make the script executable
chmod +x ~/.devcontainer/scripts/activate-venv.sh

# Remove any existing activate entries from .bashrc
sed -i '/devcontainer\/scripts\/activate-venv/d' ~/.bashrc

# Add our activation script to .bashrc
echo "source ~/.devcontainer/scripts/activate-venv.sh" >> ~/.bashrc

# Execute the activation script once to activate the venv in the current shell
source ~/.devcontainer/scripts/activate-venv.sh

echo "Virtual environment setup complete."
