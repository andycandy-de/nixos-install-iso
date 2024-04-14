{ config, lib, pkgs, modulesPath, ... }:                                                 
                                                                                         
let
  cfg = config.swapfile;
in {
  options.swapfile = {
    size = lib.mkOption {
      type = lib.types.int;
      default = 2 * 1024;
    };
    file = lib.mkOption {                                                              
      type = lib.types.str;                                                                
      default = "/var/lib/swapfile";
    };
    encrypted = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
  };
  config = { 
    swapDevices = [ {
      device = cfg.file;
      size = cfg.size;
      randomEncryption.enable = cfg.encrypted;
    } ];
  };
}
