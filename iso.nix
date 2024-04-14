{ config, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>
  ];

  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";
  };
  
  environment.systemPackages = with pkgs; [
    gum
    (
      writeShellScriptBin "install-nix"
        ''
          if [ `id -u` -ne 0 ]
            then echo Please run this script as root or using sudo!
            exit
          fi

          INSTALL_DISK=$(find /dev/ -regex '\/dev\/[sv]d[a-z]' | gum choose --select-if-one --header="Select disk to install nixos!")

          gum confirm --default=false "Are you sure to install nixos to $INSTALL_DISK? All data will be lost!" || exit

          parted -s $INSTALL_DISK -- mklabel msdos
          parted -s $INSTALL_DISK -- mkpart primary 1MB 100%
          parted -s $INSTALL_DISK -- set 1 boot on
          mkfs.ext4 -F -L nixos "$INSTALL_DISK"1

          mount "$INSTALL_DISK"1 /mnt
          nixos-generate-config --root /mnt
          cp -R -f /etc/install_nixos_config/* /mnt/etc/nixos/

          if [ "$INSTALL_DISK" != "/dev/sda" ]
            then sed -i "s|/dev/sda|$INSTALL_DISK|g" /mnt/etc/nixos/bootloader-mbr.nix
          fi

          nixos-install --no-root-passwd
          nixos-enter --root /mnt -c 'passwd nixos'

          gum confirm --affirmative="OK" --negative="" --timeout=59s "System will be rebooted. Eject the install media!" && reboot
        ''
    )
  ];
  
  environment.etc = {
    install_nixos_config.source = ./config;
  };

  services.getty.helpLine = ''
        _________________________________________________________
       |                                                         |
       | You can start the installation with 'sudo install-nix'! |
      .|_________________________________________________________|
    '';
}
