{ config, pkgs, ... }:

{

  imports = [
    /etc/nixos/hardware-configuration.nix
    ./neeraj.nix
  ];

  boot = {
    blacklistedKernelModules = [ "snd_pcsp" ];
    kernelPackages = pkgs.linuxPackages_latest;
    tmp.cleanOnBoot = true;
    loader = {
      # systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        copyKernels = true;
        # efiInstallAsRemovable = true;
        efiSupport = true;
        # fsIdentifier = "label";
        # splashImage = ./backgrounds/grub-nixos-3.png;
        # splashMode = "stretch";
        devices = [ "nodev" ];
        extraEntries = ''
          menuentry "Reboot" {
            reboot
          }
          menuentry "Poweroff" {
            halt
          }
        '';
      };
    };
    supportedFilesystems = [
      "ntfs"
    ];
  };

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
    hostName = "Nimbus-2021";
    networkmanager.enable = true;
  };

  time.timeZone = "Asia/Kolkata";
  i18n = {
    defaultLocale = "en_IN";
    extraLocaleSettings = {
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
  };

  sound.enable = true;

  services = {
    xserver = {
      layout = "us";
      xkbVariant = "";
      enable = true;
      # windowManager.qtile.enable = true;
      windowManager.i3 = {
        enable = true;
        extraPackages = with pkgs; [
          i3status
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
      displayManager = {
        lightdm.enable = true;
        defaultSession = "xfce+i3";
      };
    };
    gvfs.enable = true;
    gnome.gnome-keyring.enable = true;
    blueman.enable = true; # enable while using blueman
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      pulseaudio = true;
    };
  };

  environment.systemPackages = with pkgs; [ ];

  programs = {
    thunar.enable = true;
    dconf.enable = true;
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
  };

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

  virtualisation.libvirtd.enable = true;
  
  hardware = {
    bluetooth.enable = true;
  };

  # Don't touch this
  system.stateVersion = "23.05";
}
