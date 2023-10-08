{ config, pkgs, ... }:

{
  home.username = "neeraj";
  home.homeDirectory = "/home/neeraj";
  home.stateVersion = "23.05";
	
  home.packages = with pkgs; [
    libcanberra
    brave
    electron_25
    glaxnimate # requierd but kdenlive
    inkscape
    libsForQt5.kdenlive
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
