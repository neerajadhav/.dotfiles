# neeraj.nix

{ config, lib, pkgs, ... }:

let
  /*
  sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
  sudo nix-channel --update
  */
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };

  unstableApps = with pkgs; with unstable; [
    brave
    electron_25
    obsidian
    virt-manager
    virtualenv
    vlc
    vscode
    xarchiver
    zoom-us
  ];

  commonStableApps = with pkgs; [
    gh
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
    xfce.thunar-archive-plugin
  ];

  wmTools = with pkgs; [
    alacritty
    dmenu
    git
    gnome.gnome-keyring
    nerdfonts
    networkmanagerapplet
    nitrogen
    pasystray
    picom
    polkit_gnome
    pulseaudioFull
    rofi
    vim
    unrar
    unzip
  ];

  appendAppList = apps: wmTools ++ unstableApps ++ commonStableApps ++ apps;

in {
  # User settings
  users.users.neeraj = {
    isNormalUser = true;
    description = "Neeraj";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; appendAppList [ ];
  };
}
