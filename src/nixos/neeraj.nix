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
      unstable.maestral # open-source dropbox client
      unstable.obsidian
      unstable.virtualenv
      unstable.vscode
      unstable.zoom-us
    ];

  };
}
