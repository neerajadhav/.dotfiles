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
    blueman
    dmenu
    dunst
    gnome.gnome-keyring
    libnotify
    libsecret
    nitrogen
    xfce.thunar
  ];

  # Gnome specific packages
  gnomeApps = with pkgs; [
    gnome.gnome-tweaks
  ];

  # XFCE Specific packages
  xfceApps = with pkgs; with xfce; [
    xfce4-pulseaudio-plugin
  ];

  # KDE Specific packages
  kdeApps = with pkgs; with libsForQt5; [
    plasma-browser-integration
  ];

  # Unstable apps
  unstableApps = with pkgs; with unstable; [
    nodejs_20
    obsidian
    virt-manager
    virtualenv
    vlc
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
    htop
    hugo
    maestral
    maestral-gui
    micro
    motrix
    neofetch
    onlyoffice-bin
    parted
    python3
    ventoy-full
  ];

  appendApps = apps: kdeApps ++ unstableApps ++  commonStableApps ++ apps;

in {
  users.users.neeraj = {
    isNormalUser = true;
    description = "Neeraj";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; appendApps [];
  };
}
