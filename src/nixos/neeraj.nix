# neeraj.nix

{ config, lib, pkgs, ... }:

let
  /*
  sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
  sudo nix-channel --update
  */
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
  
  # qtile specific packages
  qtileApps = with pkgs; [
    cowsay
  ];

  # unstable apps here
  unstableApps = with pkgs; with unstable; [
    maestral
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
    gnome.gnome-keyring
    gnome.gnome-tweaks
    htop
    micro
    neofetch
    onlyoffice-bin
    python3
  ];

  appendApps = apps: qtileApps ++ unstableApps ++  commonStableApps ++ apps;

in {
  users.users.neeraj = {
    isNormalUser = true;
    description = "Neeraj";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; appendApps [];
  };
}
