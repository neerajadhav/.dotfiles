# neeraj.nix

{ config, lib, pkgs, ... }:

{
  users.users.neeraj = {
    isNormalUser = true;
    description = "Neeraj";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      flatpak
        # This is the list of flatpak apps to be installed from flathub
        /*
        vscode 
        */
      firefox
      brave
      micro
      gnome.gnome-tweaks
      gnome.gnome-keyring
      # other packages
    ];
  };
}
