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
      cpeditor
      brave
      dropbox # not working TODO: find solution
      dropbox-cli
      firefox
      gh
      git
      gnome.gnome-keyring
      gnome.gnome-tweaks
      htop
      micro
      neofetch
      onlyoffice-bin
      python3 # for latest stable python
      unstable.obsidian
      unstable.virtualenv # very important for python
      unstable.vscode
      unstable.zoom-us
    ];
  };
}
