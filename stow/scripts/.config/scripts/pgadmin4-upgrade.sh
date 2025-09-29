#!/bin/bash

VENV_DIR="$HOME/.local/share/pgadmin4-venv"

echo "👉 Activate env"
source "$VENV_DIR/bin/activate"

echo "👉 Upgrade pip ..."
pip install --upgrade pip

echo "👉 Upgrade pgAdmin4 ..."
pip install --upgrade pgadmin4

echo "👉 Upgraded pgAdmin4 version:"
pip show pgadmin4 | grep Version
