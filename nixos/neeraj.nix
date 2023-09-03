# neeraj.nix

{ config, lib, pkgs, ... }:

{
  users.users.neeraj = {
    isNormalUser = true;
    description = "Neeraj";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      brave
      micro
      gnome.gnome-tweaks
      gnome.gnome-keyring
      gh
      # other packages
    ];
  };
}
