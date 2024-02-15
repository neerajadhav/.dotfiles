> [!WARNING]  
> The DotFiles Setup Script is currently in development
> and is not ready for use. If you would like to
> contribute, please raise an issue or 
> submit a pull request.

# DotFiles Setup Script

This script helps you manage your dotfiles by setting up a symbolic link for the `.profile` file and applying Nix configuration files from a predefined directory.

## Features

- **DotProfile Setup**: Creates a backup of your existing `.profile` file (if it exists) and replaces it with a symbolic link to a customized `.profile` file in your dotfiles directory.

- **Nix Configuration**: Backs up existing Nix configuration files in `/etc/nixos`, then replaces them with symbolic links to configuration files located in your dotfiles directory's `nixos` subfolder.

## Prerequisites

- Bash (Bourne Again Shell)
- Linux-based operating system
- Nix package manager (for Nix configuration)

## Getting Started

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/neerajadhav/.dotfiles.git ~/.dotfiles
   ```

2. Make sure to navigate to the directory containing the script.

3. Run the script using:

   ```bash
   sh ./install.sh
   ```

## Usage

When you run the script, it will present you with a menu to choose from:

1. **Set dotProfile**: This option sets up the `.profile` file as a symbolic link to the customized version in the dotfiles directory.

2. **Apply Nix configuration**: This option backs up and replaces Nix configuration files in `/etc/nixos` with symbolic links to the files in the `nixos` subfolder of your dotfiles directory.

3. **Exit**: This option exits the script.

Choose the desired option by entering its corresponding number.

## Backup

- Existing `.profile` and Nix configuration files will be backed up in a `backup` directory created within the script's directory.

## Author

- Neeraj Adhav

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details.
