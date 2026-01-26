#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Running install_software.sh..."
if ! "${SCRIPT_DIR}/install_software.sh"; then
    echo "Error: install_software.sh failed."
    exit 1
fi

echo "Adding winget_shims to user PATH..."
if ! powershell.exe -NoProfile -ExecutionPolicy Bypass -File "${SCRIPT_DIR}/add_winget_shims_to_path.ps1"; then
    echo "Error: add_winget_shims_to_path.ps1 failed."
    exit 1
fi

echo "Windows setup completed successfully."
