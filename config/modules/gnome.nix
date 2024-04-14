{ config, pkgs, ... }:

{
  imports = [];
  
  services.xserver.enable = true;                                                                                                      
  services.xserver.desktopManager.gnome.enable = true;                                                                                 
  services.xserver.displayManager.gdm.enable = true; 
                                                                                                                                       
  services.gnome.tracker-miners.enable = false;                                                                                        
  services.gnome.tracker.enable = false;

  environment.gnome.excludePackages = (with pkgs; [                                                                                    
    gnome-photos                                                                                                                       
    gnome-tour                                                                                                                         
  ]) ++ (with pkgs.gnome; [                                                                                                            
    cheese # webcam tool                                                                                                               
    gnome-music                                                                                                                        
    epiphany # web browser                                                                                                             
    geary # email reader                                                                                                               
    gnome-characters                                                                                                                   
    totem # video player                                                                                                               
    tali # poker game                                                                                                                  
    iagno # go game                                                                                                                    
    hitori # sudoku game                                                                                                               
    atomix # puzzle game                                                                                                               
  ]);
                                                                                                                                       
  services.xserver.xkb.layout = "de";

  virtualisation.virtualbox.guest.enable = true;                                                                                       
  virtualisation.virtualbox.guest.x11 = true;
}
