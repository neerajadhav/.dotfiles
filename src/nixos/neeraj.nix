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
    inkscape
    nodejs_20
    obsidian
    virt-manager
    virtualenv
    vlc
    vscode
    xarchiver
    zoom-us
  ];

  gamingApps = with pkgs; [
    # wineWowPackages.stable
    # lutris
    # bottles
    # steam
  ];

  commonStableApps = with pkgs; [
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
    xfce.thunar-archive-plugin
    xfce.xfce4-volumed-pulse
  ];

  wmTools = with pkgs; [
    # acpi
    # bc
    # calc
    dmenu
    git
    gnome.gnome-keyring
    killall
    kitty
    networkmanagerapplet
    nitrogen
    pasystray
    pciutils
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
