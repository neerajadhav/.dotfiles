#!/bin/bash

YELLOW="\e[93m"
GREEN="\e[32m"
RED="\e[91m"
RESET="\e[0m"

HOME_DIR="$HOME"
DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="./backup"
LOG_FILE="function_log.txt"

set_dotProfile() {
    if [ -f "$LOG_FILE" ] && grep -q "set_dotProfile" "$LOG_FILE"; then
        echo -e "${RED}set_dotProfile has already been executed.${RESET}"
        return
    fi

    PROFILE_FILE="$HOME/.profile"
    DOTPROFILE_FILE="$DOTFILES_DIR/src/.profile"

    mkdir -p "$BACKUP_DIR"

    if [ -f "$PROFILE_FILE" ]; then
        cp "$PROFILE_FILE" "$BACKUP_DIR/.profile_$(date +'%Y%m%d%H%M%S').bak"
        echo -e "${YELLOW}Backup of .profile created in the backup directory.${RESET}"
        rm "$PROFILE_FILE"
        echo -e "${RED}Existing .profile removed from the home directory.${RESET}"
    fi

    ln -s "$DOTPROFILE_FILE" "$PROFILE_FILE"
    echo -e "${GREEN}Created a symbolic link to .profile in the home directory.${RESET}"

    echo "set_dotProfile $(date +'%Y%m%d%H%M%S')" >>"$LOG_FILE"
    echo -e "${GREEN}DotProfile setup complete.${RESET}"
}

apply_nix_configuration() {
    if [ -f "$LOG_FILE" ] && grep -q "apply_nix_configuration" "$LOG_FILE"; then
        echo -e "${RED}apply_nix_configuration has already been executed.${RESET}"
        return
    fi

    NIXOS_DIR="/etc/nixos"
    DOTFILES_NIXOS_DIR="$DOTFILES_DIR/src/nixos"

    if [ -d "$NIXOS_DIR" ]; then
        if [ "$(ls -A "$NIXOS_DIR")" ]; then
            mkdir -p "$BACKUP_DIR/nixos"
        fi
        for file in "$NIXOS_DIR"/*; do
            if [ -f "$file" ]; then
                echo -e "Backing up $(basename "$file") in $NIXOS_DIR..."
                cp "$file" "$BACKUP_DIR/nixos/$(basename "$file")_$(date +'%Y%m%d%H%M%S').bak"
                echo -e "${YELLOW}Backup Created:${RESET} $(basename "$file") to $BACKUP_DIR/nixos."
                sudo rm "$file"
                echo -e "${RED}Removed file:${RESET} $(basename "$file") from $NIXOS_DIR."
            fi
        done

        for file in "$DOTFILES_NIXOS_DIR"/*; do
            if [ -f "$file" ]; then
                sudo ln -s "$file" "$NIXOS_DIR/$(basename "$file")"
                echo -e "${GREEN}Symlink Created:${RESET} For $(basename "$file") in $NIXOS_DIR."
            fi
        done

        echo "apply_nix_configuration $(date +'%Y%m%d%H%M%S')" >>"$LOG_FILE"
        echo -e "${GREEN}Nix configuration applied successfully.${RESET}"
    else
        echo -e "${RED}${NIXOS_DIR} does not exist.${RESET} Skipping the backup and symlink creation."
    fi
}

apply_qtile_configuration() {
    if [ -f "$LOG_FILE" ] && grep -q "apply_qtile_configuration" "$LOG_FILE"; then
        echo -e "${RED}apply_qtile_configuration has already been executed.${RESET}"
        return
    fi

    QTILE_CONFIG_DIR="$HOME/.config/qtile"
    DOTFILES_QTILE_DIR="$DOTFILES_DIR/src/qtile"

    if [ -d "$QTILE_CONFIG_DIR" ]; then
        if [ "$(ls -A "$QTILE_CONFIG_DIR")" ]; then
            mkdir -p "$BACKUP_DIR/qtile"
        fi
        for file in "$QTILE_CONFIG_DIR"/*; do
            if [ -f "$file" ]; then
                echo -e "Backing up $(basename "$file") in $QTILE_CONFIG_DIR..."
                cp "$file" "$BACKUP_DIR/qtile/$(basename "$file")_$(date +'%Y%m%d%H%M%S').bak"
                echo -e "${YELLOW}Backup Created:${RESET} $(basename "$file") to $BACKUP_DIR/qtile."
                rm "$file"
                echo -e "${RED}Removed file:${RESET} $(basename "$file") from $QTILE_CONFIG_DIR."
            fi
        done

        for file in "$DOTFILES_QTILE_DIR"/*; do
            if [ -f "$file" ]; then
                ln -s "$file" "$QTILE_CONFIG_DIR/$(basename "$file")"
                echo -e "${GREEN}Symlink Created:${RESET} For $(basename "$file") in $QTILE_CONFIG_DIR."
            fi
        done

        echo "apply_qtile_configuration $(date +'%Y%m%d%H%M%S')" >>"$LOG_FILE"
        echo -e "${GREEN}Qtile configuration applied successfully.${RESET}"

    else
        echo -e "${RED}${QTILE_CONFIG_DIR} does not exist.${RESET} Skipping the backup and symlink creation."
    fi
}

show_menu() {
    clear
    echo -e "======================\n"
    echo -e "DotFiles Menu\n"

    if [ -f "$LOG_FILE" ] && grep -q "set_dotProfile" "$LOG_FILE"; then
        echo -e "1. [${GREEN}✓${RESET}] Set dotProfile"
    else
        echo -e "1. [${RED}✗${RESET}] Set dotProfile"
    fi

    if [ -f "$LOG_FILE" ] && grep -q "apply_nix_configuration" "$LOG_FILE"; then
        echo -e "1. [${GREEN}✓${RESET}] Apply Nix configuration"
    else
        echo -e "1. [${GREEN}✓${RESET}] Apply Nix configuration"
    fi

    if [ -f "$LOG_FILE" ] && grep -q "apply_qtile_configuration" "$LOG_FILE"; then
        echo -e "3. [${GREEN}✓${RESET}] Apply Qtile configuration"
    else
        echo -e "3. [${RED}✗${RESET}] Apply Qtile configuration"
    fi

    echo "4. Exit"
    echo -e "\n======================\n"
}

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
        apply_qtile_configuration
        ;;
    4)
        echo "Exiting the script."
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid choice. Please enter a valid option.${RESET}"
        ;;
    esac
    read -n 1 -s -r -p "Press any key to continue..."
done
