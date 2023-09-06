# neeraj.nix

{ config, lib, pkgs, ... }:

let
  /*
  sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
  sudo nix-channel --update
  */
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
  
  # Qtile specific packages
  qtileApps = with pkgs; [
    alacritty
    dmenu
    dunst
    libnotify
    nitrogen
    xfce.thunar
  ];

  # Gnome specific packages
  gnomeApps = with pkgs; [
    gnome.gnome-tweaks
  ];

  # Unstable apps
  unstableApps = with pkgs; with unstable; [
    obsidian
    virtualenv
    vscode
    zoom-us
  ];

  # Apps to be installed irrespective of desktop env
  commonStableApps = with pkgs; [
    brave
    firefox
    gh
    git
    gparted
    gnome.gnome-keyring
    htop
    libsecret
    micro
    motrix
    neofetch
    onlyoffice-bin
    python3
    ventoy-full
  ];

  appendApps = apps: unstableApps ++  commonStableApps ++ apps;

in {
  users.users.neeraj = {
    isNormalUser = true;
    description = "Neeraj";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; appendApps [];
  };
}
