#!/bin/bash

NAME="Matas Ramanauskas"
EMAIL="matas.ramanauskas@revelsystems.com"

# Get the root path of the current Git repository
REPO_ROOT=$(git rev-parse --show-toplevel)

# Function to generate SSH keys
generate_ssh_key() {
    key_name=$1
    echo "Generating SSH key: $key_name"

    # Generate the SSH key with ed25519 type without a passphrase
    ssh-keygen -t ed25519 -f "$HOME/.ssh/$key_name" -C "$key_name" -N ""

    if [ $? -eq 0 ]; then
        echo "$key_name has been generated successfully."
    else
        echo "Error generating $key_name."
    fi
}

# Function to backup existing SSH config and copy a new one from the repo
update_ssh_config() {

    # Define the paths
    SSH_CONFIG="$HOME/.ssh/config"
    NEW_CONFIG="$REPO_ROOT/macOS/config"

    # Check if the current config file exists and back it up
    if [ -f "$SSH_CONFIG" ]; then
        echo "Backing up existing SSH config to $SSH_CONFIG.bak"
        cp "$SSH_CONFIG" "$SSH_CONFIG.bak"
    fi

    # Copy the new config file to ~/.ssh/config
    if [ -f "$NEW_CONFIG" ]; then
        echo "Copying new SSH config from $NEW_CONFIG to $SSH_CONFIG"
        cp "$NEW_CONFIG" "$SSH_CONFIG"
        echo "SSH config has been updated."
    else
        echo "New config file not found: $NEW_CONFIG"
    fi
}

# Function to generate a new GPG key without an expiration date
generate_gpg_key() {
    echo "Generating a new RSA GPG key with no expiration date..."

    # Define key details for RSA and disable interactive pinentry mode
    gpg --batch --pinentry-mode loopback --generate-key <<EOF
%no-protection
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: "$NAME"
Name-Email: "$EMAIL"
Expire-Date: 0
%commit
EOF

    if [ $? -eq 0 ]; then
        echo "GPG key generated successfully."
    else
        echo "Error generating GPG key."
    fi
}

# Function to display the public GPG key
display_gpg_public_key() {
    echo "Fetching the public GPG key..."

    # Get the fingerprint of the most recent GPG key
    GPG_FINGERPRINT=$(gpg --list-keys --with-colons | grep '^fpr' | head -n 1 | cut -d':' -f10)

    if [ -n "$GPG_FINGERPRINT" ]; then
        echo "Public GPG key:"
        gpg --armor --export "$GPG_FINGERPRINT"
    else
        echo "No GPG key found."
    fi
}

# Function to set global Git configuration and add aliases from a file
set_git_config() {
    ALIAS_FILE="$REPO_ROOT/macOS/git_alias"
    # Check if NAME and EMAIL are provided
    if [ -z "$NAME" ] || [ -z "$EMAIL" ]; then
        echo "Usage: set_git_config <name> <email> [alias_file]"
        return 1
    fi

    # Set global Git configuration
    git config --global user.name "$NAME"
    git config --global user.email "$EMAIL"
    git config --global pull.rebase true

    # Enable GPG signing for commits
    git config --global commit.gpgSign true

    # Get the GPG key fingerprint
    GPG_FINGERPRINT=$(gpg --list-secret-keys --with-colons | grep '^fpr' | head -n 1 | cut -d':' -f10)

    # Set the GPG key for signing
    if [ -n "$GPG_FINGERPRINT" ]; then
        git config --global user.signingkey "$GPG_FINGERPRINT"
        echo "Global Git configuration set:"
        echo "Name: $NAME"
        echo "Email: $EMAIL"
        echo "Rebase: true"
        echo "Using GPG key for signing: $GPG_FINGERPRINT"

        # Check if alias file is provided and exists
        if [ -n "$ALIAS_FILE" ] && [ -f "$ALIAS_FILE" ]; then
            echo "Appending Git aliases from $ALIAS_FILE to .gitconfig..."

            # Ensure the alias section exists
            if ! grep -q '\[alias\]' ~/.gitconfig; then
                echo "[alias]" >>~/.gitconfig
            fi

            # Append aliases to .gitconfig
            cat "$ALIAS_FILE" >>~/.gitconfig
            echo "Git aliases added."
        else
            echo "No alias file provided or file does not exist."
        fi
    else
        echo "No GPG key found. Please generate a GPG key first."
        return 1
    fi
}

# Generate regular SSH key
generate_ssh_key "id_ed25519"

# Generate personal SSH key
generate_ssh_key "id_ed25519_personal"

# Call the function
update_ssh_config

# Generate and print GPG key
generate_gpg_key
set_git_config
display_gpg_public_key
