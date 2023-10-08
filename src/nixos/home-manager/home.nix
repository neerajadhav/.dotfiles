{ config, pkgs, ... }:

{
  home.username = "neeraj";
  home.homeDirectory = "/home/neeraj";
  home.stateVersion = "23.05";
	
  home.packages = with pkgs; [
    brave
    electron_25
    inkscape
    nodejs_20
    obsidian
    virt-manager
    virtualenv
    vlc
    vscode
    zoom-us
    gimp
    gparted
    htop
    hugo
    maestral
    maestral-gui
    micro
    motrix
    neofetch
    nvtop
    onlyoffice-bin
  ];

  home.file = {};

  home.sessionVariables = {
    # EDITOR = "emacs";
  };
  programs.home-manager.enable = true;
}
