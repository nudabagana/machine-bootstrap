#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ensure_winget() {
    if ! command -v winget >/dev/null 2>&1; then
        echo "winget is required but was not found. Install winget from the Microsoft Store, then rerun this script."
        exit 1
    fi
}

# Each entry uses the format "Display Name:Package.Identifier"
packages=(
    "Git:Git.Git"
    "Codex:OpenAI.Codex"
    "VSCode:Microsoft.VisualStudioCode"
    "Brave:Brave.Brave"
    "Steam:Valve.Steam"
    "MSIAfterburner:Guru3D.Afterburner"
    "VLC:VideoLAN.VLC"
    "Spotify:Spotify.Spotify"
    "Syncthing:Syncthing.Syncthing"
    "Obsidian:Obsidian.Obsidian"
)

install_package() {
    local name="$1"
    local identifier="$2"

    if winget list --exact --id "$identifier" >/dev/null 2>&1; then
        echo "$name is already installed."
        return
    fi

    echo "Installing $name..."
    if winget install --exact --id "$identifier" --accept-package-agreements --accept-source-agreements --silent; then
        echo "$name installation complete."
    else
        echo "Failed to install $name."
    fi
}

main() {
    echo "Starting Windows software installation..."
    ensure_winget

    for entry in "${packages[@]}"; do
        IFS=":" read -r name identifier <<<"$entry"
        install_package "$name" "$identifier"
    done

    echo "Windows software installation complete."
}

main
