{ config, pkgs, ... }:

let

  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };

  unstableApps = with pkgs; with unstable; [
    brave
    obsidian
    virt-manager
    virtualenv
    vlc
    vscode
    zoom-us
  ];

  commonStableApps = with pkgs; [
    gh
    git
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
    xarchive
  ];

  wmTools = with pkgs; [
    alacritty
    dmenu
    gnome.gnome-keyring
    networkmanagerapplet
    nitrogen
    picom
    polkit_gnome
    polybarFull
    pulseaudioFull
    rofi
    unzip
  ];

  appendAppList = apps: wmTools ++ unstableApps ++ commonStableApps ++ apps;

in {
  imports = [
    /etc/nixos/hardware-configuration.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "Nimbus-2021";
  networking.networkmanager.enable = true;

  # Timezone and Locale
  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_IN";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
    LC_CTYPE="en_US.utf8"; # required by dmenu
  };

  # X Server
  services.xserver = {
    layout = "us";
    xkbVariant = "";
    enable = true;
    # windowManager.qtile.enable = true;
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        i3status
        i3lock
        i3blocks
     ];
    };
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };
    displayManager.defaultSession = "xfce+i3";
  };

  # User settings
  users.users.neeraj = {
    isNormalUser = true;
    description = "Neeraj";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
    packages = with pkgs; appendAppList [ ];
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [ ];

  # Essential programs and services
  programs.thunar.enable = true;
  # services.gvfs.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart =
          "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

  # Virtualisation
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;
  
  # Bluetooth service
  hardware.bluetooth.enable = true;
  services.blueman.enable = true; # enable while using blueman

  # Sound
  nixpkgs.config.pulseaudio = true;
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  system.stateVersion = "23.05";

}
