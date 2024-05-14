{ config, lib, pkgs, ... }:

let
  nerdfontPackage = "JetBrainsMono";
  nerdfontName = "JetBrainsMono Nerd Font Mono";
  keyboadLayout = "de";
  timeZone = "Europe/Berlin";
  locale = "de_DE.UTF-8";
in {
  imports = [
    ./hardware-configuration.nix
    ./bootloader-mbr.nix
    ./modules/zsh.nix
    # ./modules/swapfile.nix
  ];

  time.timeZone = timeZone;
  i18n.defaultLocale = locale;
  console = {
    font = "Lat2-Terminus16";
    keyMap = keyboadLayout;
  };

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "vboxsf"
      "docker"
    ];
    openssh.authorizedKeys.keys = [
    ];
  };

  environment.systemPackages = with pkgs; [
    vim
    helix
    htop
    wget
    zellij
    nnn
    firefox
    browsh
    bat
    fzf
    eza
  ];

  fonts.packages = [
    (pkgs.nerdfonts.override { fonts = [ nerdfontPackage ]; })
  ];

  # security.sudo.wheelNeedsPassword = false;

  services = {

    openssh = {
      enable = true;
      # settings.PasswordAuthentication = false;
    };

    kmscon = {
      enable = true;
      extraConfig = "xkb-layout=${keyboadLayout}";
      extraOptions = "--term xterm-256color";
      fonts = [
        {
          name = nerdfontName;
          package = (pkgs.nerdfonts.override { fonts = [ nerdfontPackage ]; });
        }
      ];
    };
  };

  # virtualisation.docker.enable = true;

  # networking.firewall.allowedTCPPorts = [];
  # networking.firewall.allowedUDPPorts = [];
  
  system.stateVersion = "23.11";
}
