#!/bin/bash

REPO_ROOT=$(git rev-parse --show-toplevel)

# Function to install Oh My Zsh if not installed
install_oh_my_zsh() {
    if [ -d "$HOME/.oh-my-zsh" ]; then
        echo "Oh My Zsh is already installed."
    else
        echo "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        if [ $? -ne 0 ]; then
            echo "Error: Oh My Zsh installation failed."
            exit 1
        fi
    fi
}

# Function to copy custom Zsh configuration files
copy_custom_files() {
    CUSTOM_DIR="$HOME/.oh-my-zsh/custom"

    echo "Copying custom Zsh configuration files..."
    cp "$REPO_ROOT/macOS/custom.zsh" "$CUSTOM_DIR" || {
        echo "Error copying custom.zsh"
        exit 1
    }
    cp "$REPO_ROOT/macOS/history.zsh" "$CUSTOM_DIR" || {
        echo "Error copying history.zsh"
        exit 1
    }
}

# Function to install plugins for Oh My Zsh
install_plugins() {
    ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    echo "Installing zsh-autosuggestions plugin..."
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions" || {
        echo "Error installing zsh-autosuggestions"
        exit 1
    }

    echo "Installing zsh-syntax-highlighting plugin..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" || {
        echo "Error installing zsh-syntax-highlighting"
        exit 1
    }
}

set_zsh_theme_and_plugins() {
    ZSHRC="$HOME/.zshrc"

    echo "Setting Zsh theme to 'agnoster' and updating plugins..."

    # Set theme to agnoster
    sed -i '' 's/^ZSH_THEME=".*"/ZSH_THEME="agnoster"/' "$ZSHRC"

    # Set plugins to git, zsh-autosuggestions, zsh-syntax-highlighting, history, and docker
    sed -i '' 's/^plugins=(.*)/plugins=(git zsh-autosuggestions zsh-syntax-highlighting history docker)/' "$ZSHRC"
}

# Run the functions
install_oh_my_zsh
copy_custom_files
install_plugins
set_zsh_theme_and_plugins

echo "Oh My Zsh setup completed successfully."
