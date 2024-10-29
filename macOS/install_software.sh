#!/bin/bash

# Check if Homebrew is installed, and install if it's missing
install_homebrew() {
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        if [ $? -eq 0 ]; then
            echo "Homebrew installed successfully."
            # Add Homebrew to PATH for this session
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            echo "Failed to install Homebrew. Exiting."
            exit 1
        fi
    else
        echo "Homebrew is already installed."
    fi
}

# Generic function to install applications via Homebrew
install_application() {
    local app_name=$1
    local identifier=$2

    if brew list --cask | grep -q "^$identifier\$"; then
        echo "$app_name is already installed."
    elif brew list | grep -q "^$identifier\$"; then
        echo "$app_name is already installed."
    else
        echo "Installing $app_name..."
        if brew info "$identifier" | grep -q "Cask"; then
            brew install --cask "$identifier"
        else
            brew install "$identifier"
        fi
        if [ $? -eq 0 ]; then
            echo "$app_name installation complete."
        else
            echo "Failed to install $app_name."
        fi
    fi
}

# List of applications to install (name and cask identifier)
applications=(
    "iTerm2:iterm2"
    "Brave Browser:brave-browser"
    "Visual Studio Code:visual-studio-code"
    "Obsidian:obsidian"
    "Postman:postman"
    "Spotify:spotify"
    "AWS CLI:awscli"
    "Colima:colima"
    "ctop:ctop"
    "Docker:docker"
    "Docker Compose:docker-compose"
    "Go:go"
    "htop:htop"
    "Kubernetes CLI:kubernetes-cli"
    "LLVM@14:llvm@14"
    "nmap:nmap"
    "NVM:nvm"
    "Pyenv:pyenv"
    "Terraform:terraform"
    "Tmux:tmux"
    "Watch:watch"
    "DBeaver Community:dbeaver-community"
    "Flameshot:flameshot"
    "JetBrains Toolbox:jetbrains-toolbox"
    "VLC:vlc"
    "Xcodes:xcodes"
    "Tiles:tiles"
    "Gpg2:gpg2"
    "Font-hack-nerd-font:font-hack-nerd-font"
    "Openconnect:openconnect"
)

# Main installation process
main() {
    echo "Starting software installation process..."
    install_homebrew

    # Loop through applications array and install each one
    for app in "${applications[@]}"; do
        # Split the string on colon to get name and cask
        IFS=":" read -r app_name cask_name <<< "$app"
        install_application "$app_name" "$cask_name"
    done

    echo "Software installation process complete."
}

# Run the main function
main

