#!/bin/bash

YELLOW="\e[93m"
GREEN="\e[32m"
RED="\e[91m"
RESET="\e[0m"

HOME_DIR="$HOME"
DOTFILES_DIR="$HOME/.dotfiles"
BACKUP_DIR="./backup"
LOG_FILE="function_log.txt"

backup_file() {
    local source_file="$1"
    local destination_dir="$2"

    mkdir -p "$destination_dir"
    cp "$source_file" "$destination_dir/$(basename "$source_file")_$(date +'%Y%m%d%H%M%S').bak"
    echo -e "${YELLOW}Backup Created:${RESET} $(basename "$source_file") to $destination_dir."
}

remove_file() {
    local file="$1"

    rm "$file"
    echo -e "${RED}Removed file:${RESET} $(basename "$file")"
}

create_symlink() {
    local source_file="$1"
    local destination_file="$2"

    ln -s "$source_file" "$destination_file"
    echo -e "${GREEN}Symlink Created:${RESET} For $(basename "$source_file") in $(dirname "$destination_file")."
}

check_executed() {
    local function_name="$1"

    if [ -f "$LOG_FILE" ] && grep -q "$function_name" "$LOG_FILE"; then
        return 0
    fi

    return 1
}

set_dotProfile() {
    if check_executed "set_dotProfile"; then
        echo -e "${RED}set_dotProfile has already been executed.${RESET}"
        return
    fi

    local PROFILE_FILE="$HOME/.profile"
    local DOTPROFILE_FILE="$DOTFILES_DIR/src/.profile"

    mkdir -p "$BACKUP_DIR"
    if [ -f "$PROFILE_FILE" ]; then
        backup_file "$PROFILE_FILE" "$BACKUP_DIR"
        remove_file "$PROFILE_FILE"
    fi

    create_symlink "$DOTPROFILE_FILE" "$PROFILE_FILE"

    echo "set_dotProfile $(date +'%Y%m%d%H%M%S')" >> "$LOG_FILE"
    echo -e "${GREEN}DotProfile setup complete.${RESET}"
}

apply_nix_configuration() {
    if check_executed "apply_nix_configuration"; then
        echo -e "${RED}apply_nix_configuration has already been executed.${RESET}"
        return
    fi

    local NIXOS_DIR="/etc/nixos"
    local DOTFILES_NIXOS_DIR="$DOTFILES_DIR/src/nixos"

    if [ -d "$NIXOS_DIR" ]; then
        mkdir -p "$BACKUP_DIR/nixos"

        for file in "$NIXOS_DIR"/*; do
            if [ -f "$file" ]; then
                if [ "$(basename "$file")" = "hardware-configuration.nix" ]; then
                    echo "Skipping file: $(basename "$file")"
                    continue
                fi
                echo -e "Backing up $(basename "$file") in $NIXOS_DIR..."
                backup_file "$file" "$BACKUP_DIR/nixos"
                remove_file "$file"
            fi
        done

        for file in "$DOTFILES_NIXOS_DIR"/*; do
            if [ -f "$file" ]; then
                create_symlink "$file" "$NIXOS_DIR/$(basename "$file")"
            fi
        done

        echo "apply_nix_configuration $(date +'%Y%m%d%H%M%S')" >> "$LOG_FILE"
        echo -e "${GREEN}Nix configuration applied successfully.${RESET}"
    else
        echo -e "${RED}${NIXOS_DIR} does not exist.${RESET} Skipping the backup and symlink creation."
    fi
}

apply_qtile_configuration() {
    if check_executed "apply_qtile_configuration"; then
        echo -e "${RED}apply_qtile_configuration has already been executed.${RESET}"
        return
    fi

    local QTILE_CONFIG_DIR="$HOME/.config/qtile"
    local DOTFILES_QTILE_DIR="$DOTFILES_DIR/src/qtile"

    if [ -d "$QTILE_CONFIG_DIR" ]; then
        mkdir -p "$BACKUP_DIR/qtile"

        for file in "$QTILE_CONFIG_DIR"/*; do
            if [ -f "$file" ]; then
                echo -e "Backing up $(basename "$file") in $QTILE_CONFIG_DIR..."
                backup_file "$file" "$BACKUP_DIR/qtile"
                rm "$file"
            fi
        done

        for file in "$DOTFILES_QTILE_DIR"/*; do
            if [ -f "$file" ]; then
                create_symlink "$file" "$QTILE_CONFIG_DIR/$(basename "$file")"
            fi
        done

        echo "apply_qtile_configuration $(date +'%Y%m%d%H%M%S')" >> "$LOG_FILE"
        echo -e "${GREEN}Qtile configuration applied successfully.${RESET}"
    else
        echo -e "${RED}${QTILE_CONFIG_DIR} does not exist.${RESET} Skipping the backup and symlink creation."
    fi
}

apply_picom_configuration() {
    local CONFIG_DIR="$HOME/.config/picom"
    local DOTFILES_PICOM_DIR="$DOTFILES_DIR/src/picom"

    if check_executed "apply_picom_configuration"; then
        echo -e "${RED}apply_picom_configuration has already been executed.${RESET}"
        return
    fi

    if [ -d "$CONFIG_DIR" ]; then
        mkdir -p "$BACKUP_DIR/picom"
        for file in "$CONFIG_DIR"/*; do
            if [ -f "$file" ]; then
                backup_file "$file" "$BACKUP_DIR/picom"
                rm "$file"
            fi
        done

        for file in "$DOTFILES_PICOM_DIR"/*; do
            if [ -f "$file" ]; then
                create_symlink "$file" "$CONFIG_DIR/$(basename "$file")"
            fi
        done

        echo "apply_picom_configuration $(date +'%Y%m%d%H%M%S')" >> "$LOG_FILE"
        echo -e "${GREEN}Picom configuration applied successfully.${RESET}"
    else
        echo -e "${RED}${CONFIG_DIR} does not exist.${RESET} Skipping the backup and symlink creation."
    fi
}

apply_i3_configuration() {
    local CONFIG_DIR="$HOME/.config/i3"
    local DOTFILES_I3_DIR="$DOTFILES_DIR/src/i3"

    if check_executed "apply_i3_configuration"; then
        echo -e "${RED}apply_i3_configuration has already been executed.${RESET}"
        return
    fi

    if [ -d "$CONFIG_DIR" ]; then
        mkdir -p "$BACKUP_DIR/i3"
        for file in "$CONFIG_DIR"/*; do
            if [ -f "$file" ]; then
                backup_file "$file" "$BACKUP_DIR/i3"
                rm "$file"
            fi
        done

        for file in "$DOTFILES_I3_DIR"/*; do
            if [ -f "$file" ]; then
                create_symlink "$file" "$CONFIG_DIR/$(basename "$file")"
            fi
        done

        echo "apply_i3_configuration $(date +'%Y%m%d%H%M%S')" >> "$LOG_FILE"
        echo -e "${GREEN}i3 configuration applied successfully.${RESET}"
    else
        echo -e "${RED}${CONFIG_DIR} does not exist.${RESET} Skipping the backup and symlink creation."
    fi
}

apply_polybar_configuration() {
    local CONFIG_DIR="$HOME/.config/polybar"
    local DOTFILES_POLYBAR_DIR="$DOTFILES_DIR/src/polybar"

    if check_executed "apply_polybar_configuration"; then
        echo -e "${RED}apply_polybar_configuration has already been executed.${RESET}"
        return
    fi

    if [ -d "$CONFIG_DIR" ]; then
        mkdir -p "$BACKUP_DIR/polybar"
        for file in "$CONFIG_DIR"/*; do
            if [ -f "$file" ]; then
                backup_file "$file" "$BACKUP_DIR/polybar"
                rm "$file"
            fi
        done

        for file in "$DOTFILES_POLYBAR_DIR"/*; do
            if [ -f "$file" ]; then
                create_symlink "$file" "$CONFIG_DIR/$(basename "$file")"
            fi
        done

        echo "apply_polybar_configuration $(date +'%Y%m%d%H%M%S')" >> "$LOG_FILE"
        echo -e "${GREEN}Polybar configuration applied successfully.${RESET}"
    else
        echo -e "${RED}${CONFIG_DIR} does not exist.${RESET} Skipping the backup and symlink creation."
    fi
}

apply_rofi_configuration() {
    local CONFIG_DIR="$HOME/.config/rofi"
    local DOTFILES_ROFI_DIR="$DOTFILES_DIR/src/rofi"

    if check_executed "apply_rofi_configuration"; then
        echo -e "${RED}apply_rofi_configuration has already been executed.${RESET}"
        return
    fi

    if [ -d "$CONFIG_DIR" ]; then
        mkdir -p "$BACKUP_DIR/rofi"
        for file in "$CONFIG_DIR"/*; do
            if [ -f "$file" ]; then
                backup_file "$file" "$BACKUP_DIR/rofi"
                rm "$file"
            fi
        done

        for file in "$DOTFILES_ROFI_DIR"/*; do
            if [ -f "$file" ]; then
                create_symlink "$file" "$CONFIG_DIR/$(basename "$file")"
            fi
        done

        echo "apply_rofi_configuration $(date +'%Y%m%d%H%M%S')" >> "$LOG_FILE"
        echo -e "${GREEN}Rofi configuration applied successfully.${RESET}"
    else
        echo -e "${RED}${CONFIG_DIR} does not exist.${RESET} Skipping the backup and symlink creation."
    fi
}

apply_alacritty_configuration() {
    local CONFIG_DIR="$HOME/.config/alacritty"
    local DOTFILES_ALACRITTY_DIR="$DOTFILES_DIR/src/alacritty"

    if check_executed "apply_alacritty_configuration"; then
        echo -e "${RED}apply_alacritty_configuration has already been executed.${RESET}"
        return
    fi

    if [ -d "$CONFIG_DIR" ]; then
        mkdir -p "$BACKUP_DIR/alacritty"
        for file in "$CONFIG_DIR"/*; do
            if [ -f "$file" ]; then
                backup_file "$file" "$BACKUP_DIR/alacritty"
                rm "$file"
            fi
        done

        for file in "$DOTFILES_ALACRITTY_DIR"/*; do
            if [ -f "$file" ]; then
                create_symlink "$file" "$CONFIG_DIR/$(basename "$file")"
            fi
        done

        echo "apply_alacritty_configuration $(date +'%Y%m%d%H%M%S')" >> "$LOG_FILE"
        echo -e "${GREEN}Alacritty configuration applied successfully.${RESET}"
    else
        echo -e "${RED}${CONFIG_DIR} does not exist.${RESET} Skipping the backup and symlink creation."
    fi
}

show_menu() {
    clear
    echo -e "======================\n"
    echo -e "DotFiles Menu\n"

    local dotProfile_status="[${RED}✗${RESET}]"
    local nix_configuration_status="[${RED}✗${RESET}]"
    local qtile_configuration_status="[${RED}✗${RESET}]"
    local picom_configuration_status="[${RED}✗${RESET}]"
    local i3_configuration_status="[${RED}✗${RESET}]"
    local polybar_configuration_status="[${RED}✗${RESET}]"
    local rofi_configuration_status="[${RED}✗${RESET}]"
    local alacritty_configuration_status="[${RED}✗${RESET}]"

    if check_executed "set_dotProfile"; then
        dotProfile_status="[${GREEN}✓${RESET}]"
    fi

    if check_executed "apply_nix_configuration"; then
        nix_configuration_status="[${GREEN}✓${RESET}]"
    fi

    if check_executed "apply_qtile_configuration"; then
        qtile_configuration_status="[${GREEN}✓${RESET}]"
    fi

    if check_executed "apply_picom_configuration"; then
        picom_configuration_status="[${GREEN}✓${RESET}]"
    fi

    if check_executed "apply_i3_configuration"; then
        i3_configuration_status="[${GREEN}✓${RESET}]"
    fi

    if check_executed "apply_polybar_configuration"; then
        polybar_configuration_status="[${GREEN}✓${RESET}]"
    fi

    if check_executed "apply_rofi_configuration"; then
        rofi_configuration_status="[${GREEN}✓${RESET}]"
    fi

    if check_executed "apply_alacritty_configuration"; then
        alacritty_configuration_status="[${GREEN}✓${RESET}]"
    fi

    echo -e "1. $dotProfile_status Set dotProfile"
    echo -e "2. $nix_configuration_status Apply Nix configuration"
    echo -e "3. $qtile_configuration_status Apply Qtile configuration"
    echo -e "4. $picom_configuration_status Apply Picom configuration"
    echo -e "5. $i3_configuration_status Apply i3 configuration"
    echo -e "6. $polybar_configuration_status Apply Polybar configuration"
    echo -e "7. $rofi_configuration_status Apply Rofi configuration"
    echo -e "8. $alacritty_configuration_status Apply Alacritty configuration"
    echo "0. Exit"
    echo -e "\n======================\n"
}

execute_selected_functions() {
    local selected_functions="$1"
    local IFS=" "
    local function_numbers=($selected_functions)

    for number in "${function_numbers[@]}"; do
        case $number in
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
            apply_picom_configuration
            ;;
        5)
            apply_i3_configuration
            ;;
        6)
            apply_polybar_configuration
            ;;
        7)
            apply_rofi_configuration
            ;;
        8)
            apply_alacritty_configuration
            ;;
        0)
            echo "Exiting the script."
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid function number: $number. Skipping.${RESET}"
            ;;
        esac
    done
}

while true; do
    show_menu
    read -p "Enter the function numbers to execute (space-separated): " selected_functions
    execute_selected_functions "$selected_functions"

    read -n 1 -s -r -p "Press any key to continue..."
done

# while true; do
#     show_menu
#     read -p "Enter your choice: " choice
#     case $choice in
#     1)
#         set_dotProfile
#         ;;
#     2)
#         apply_nix_configuration
#         ;;
#     3)
#         apply_qtile_configuration
#         ;;
#     4)
#         apply_picom_configuration
#         ;;
#     5)
#         apply_i3_configuration
#         ;;
#     6)
#         apply_polybar_configuration
#         ;;
#     7)
#         apply_rofi_configuration
#         ;;
#     8)
#         apply_alacritty_configuration
#         ;;
#     9)
#         echo "Exiting the script."
#         exit 0
#         ;;
#     *)
#         echo -e "${RED}Invalid choice. Please enter a valid option.${RESET}"
#         ;;
#     esac
#     read -n 1 -s -r -p "Press any key to continue..."
# done
