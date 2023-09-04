# neeraj.nix

{ config, lib, pkgs, ... }:

let
  /*
  sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
  sudo nix-channel --update
  */
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in {
  users.users.neeraj = {
    isNormalUser = true;
    description = "Neeraj";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      # cpeditor # not showing icon in overview TODO: find solution
      
      # Brave - A web browser known for its privacy features.
      brave

      # Dropbox - A file hosting service and cloud storage solution. (Not working - TODO: find a solution)
      # dropbox

      # Dropbox Command-Line Interface
      # dropbox-cli

      # Firefox - A popular open-source web browser developed by Mozilla.
      firefox

      # GitHub CLI (gh) - A command-line tool for interacting with GitHub repositories.
      gh

      # Git - A distributed version control system commonly used for software development.
      git

      # GNOME Keyring - A password manager and secure storage system for user credentials.
      gnome.gnome-keyring

      # GNOME Tweaks - A tool for customizing and configuring the GNOME desktop environment.
      gnome.gnome-tweaks

      # htop - An interactive process viewer and system monitoring tool.
      htop

      # Micro - A lightweight and terminal-based text editor.
      micro

      # Neofetch - A command-line system information tool that displays system details and a logo.
      neofetch

      # OnlyOffice-bin - An office suite compatible with Microsoft Office formats.
      onlyoffice-bin

      # Python 3 - The latest stable version of the Python programming language.
      python3

      # Obsidian (Unstable) - A powerful note-taking and knowledge management tool.
      unstable.obsidian

      # Virtualenv (Unstable) - A tool for creating isolated Python environments. (Very important for Python development)
      unstable.virtualenv

      # Visual Studio Code (Unstable) - A popular code editor developed by Microsoft.
      unstable.vscode

      # Zoom (Unstable) - A video conferencing and communication platform.
      unstable.zoom-us
    ];

  };
}
