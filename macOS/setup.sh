#!/bin/bash

# Run the install_software.sh script
echo "Running install_software.sh..."
./install_software.sh
if [ $? -ne 0 ]; then
    echo "Error: install_software.sh failed."
    exit 1
fi

# Run the generate_ssh_keys.sh script
echo "Running generate_ssh_keys.sh..."
./generate_ssh_keys.sh
if [ $? -ne 0 ]; then
    echo "Error: generate_ssh_keys.sh failed."
    exit 1
fi

# Run the setup_oh_my_zsh.sh script
echo "Running setup_oh_my_zsh.sh..."
./setup_oh_my_zsh.sh
if [ $? -ne 0 ]; then
    echo "Error: setup_oh_my_zsh.sh failed."
    exit 1
fi

# Run the setup_ai.sh script
echo "Running setup_ai.sh..."
./setup_ai.sh
if [ $? -ne 0 ]; then
    echo "Error: setup_ai.sh failed."
    exit 1
fi

echo "Setup completed successfully."
