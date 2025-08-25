#!/bin/bash

set -e

# Determine repo root to locate the source config
REPO_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)

SOURCE_CONFIG="$REPO_ROOT/macOS/codex_config.toml"
TARGET_DIR="$HOME/.codex"
TARGET_CONFIG="$TARGET_DIR/config.toml"

echo "Setting up Codex config..."

# Validate source exists
if [ ! -f "$SOURCE_CONFIG" ]; then
  echo "Error: source config not found at $SOURCE_CONFIG"
  exit 1
fi

# Ensure target directory exists
mkdir -p "$TARGET_DIR"

# Backup existing config if present
if [ -f "$TARGET_CONFIG" ]; then
  TS=$(date +%Y%m%d%H%M%S)
  BACKUP="$TARGET_CONFIG.backup.$TS"
  echo "Backing up existing config to $BACKUP"
  cp "$TARGET_CONFIG" "$BACKUP"
fi

# Place new config
echo "Installing new config to $TARGET_CONFIG"
cp "$SOURCE_CONFIG" "$TARGET_CONFIG"

echo "Codex config installed."

