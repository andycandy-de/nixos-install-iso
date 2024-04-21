{ config, lib, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./bootloader-mbr.nix
    ./modules/fish.nix
    # ./modules/swapfile.nix
    # ./modules/gnome.nix
  ];

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
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

  # security.sudo.wheelNeedsPassword = false;

  environment.systemPackages = with pkgs; [
    vim
    htop
    wget
    vtm
    nnn
    firefox
    browsh
  ];

  environment.shellAliases = {
    fm = "nnn -dH && test -f \${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd && . \${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd && rm -f \${XDG_CONFIG_HOME:-$HOME/.config}/nnn/.lastd";
    wm = "vtm";
  };

  # virtualisation.docker.enable = true;

  services.openssh.enable = true;

  # networking.firewall.allowedTCPPorts = [];
  # networking.firewall.allowedUDPPorts = [];
  
  system.stateVersion = "23.11";
}
