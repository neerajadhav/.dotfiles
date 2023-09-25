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
    bottles
    gh
    gimp
    gparted
    htop
    hugo
    maestral
    maestral-gui
    micro
    motrix
    neofetch
    nomacs
    onlyoffice-bin
    parted
    python3
    ventoy-full
    wineWowPackages.stable
    xfce.thunar-archive-plugin
    xfce.xfce4-volumed-pulse
  ];

  wmTools = with pkgs; [
    acpi
    bc
    calc
    dmenu
    feh
    git
    gnome.gnome-keyring
    killall
    kitty
    nerdfonts
    networkmanagerapplet
    nitrogen
    pasystray
    picom
    polkit_gnome
    polybar
    pulseaudioFull
    pywal
    rofi
    tmux
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
