#!/bin/bash

# Define global variables
HOME_DIR="$HOME"
DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="./backup"

# Function to set the dotProfile file
set_dotProfile() {
    PROFILE_FILE="$HOME/.profile"
    DOTPROFILE_FILE="$DOTFILES_DIR/.profile"

    # Create the backup directory if it doesn't exist
    mkdir -p "$BACKUP_DIR"

    # Check if .profile exists in the home directory
    if [ -f "$PROFILE_FILE" ]; then
        # Create a backup of .profile in the backup directory
        cp "$PROFILE_FILE" "$BACKUP_DIR/.profile_$(date +'%Y%m%d%H%M%S').bak"
        echo "Backup of .profile created in the backup directory."
        rm "$PROFILE_FILE"
        echo "Existing .profile removed from the home directory."
    fi

    # Create a symbolic link to .profile in the dotfiles directory
    ln -s "$DOTPROFILE_FILE" "$PROFILE_FILE"
    echo ".profile symlink created in the home directory."

    echo "DotProfile setup complete."
}

# Function to apply Nix configuration
apply_nix_configuration() {
    # Define paths
    NIXOS_DIR="/etc/nixos"
    DOTFILES_NIXOS_DIR="$DOTFILES_DIR/nixos"

    # Create the backup directory if it doesn't exist
    mkdir -p "$BACKUP_DIR/nixos"

    # Backup existing Nix configuration files to the backup directory
    for file in "$NIXOS_DIR"/*; do
        if [ -f "$file" ]; then
            echo "Please enter your password to remove existing $(basename "$file") from $NIXOS_DIR:"
            cp "$file" "$BACKUP_DIR/nixos/$(basename "$file")_$(date +'%Y%m%d%H%M%S').bak"
            echo "$(basename "$file") - Backup created"
            sudo rm "$file"
            echo "$(basename "$file") removed from $NIXOS_DIR."
        fi
    done

    # Create symlinks for files in the .dotfiles/nixos directory
    for file in "$DOTFILES_NIXOS_DIR"/*; do
        if [ -f "$file" ]; then
            sudo ln -s "$file" "$NIXOS_DIR/$(basename "$file")"
            echo "Symlink for $(basename "$file") created in $NIXOS_DIR."
        fi
    done

    echo "Nix configuration applied successfully."
}

# Menu function
show_menu() {
    clear
    echo "=== DotFiles Menu ==="
    echo "1. Set dotProfile"
    echo "2. Apply Nix configuration"
    echo "3. Exit"
    echo "======================"
}

# Main loop
while true; do
    show_menu
    read -p "Enter your choice: " choice
    case $choice in
    1)
        set_dotProfile
        ;;
    2)
        apply_nix_configuration
        ;;
    3)
        echo "Exiting the script."
        exit 0
        ;;
    *)
        echo "Invalid choice. Please enter a valid option."
        ;;
    esac
    read -n 1 -s -r -p "Press any key to continue..."
done
