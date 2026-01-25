#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Running install_software.sh..."
if ! "${SCRIPT_DIR}/install_software.sh"; then
    echo "Error: install_software.sh failed."
    exit 1
fi

echo "Windows setup completed successfully."
