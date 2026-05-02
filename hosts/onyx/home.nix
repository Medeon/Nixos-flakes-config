{ config, pkgs, lib, userData, ... }:
{
  imports = [
    ../../modules/user/default.nix
    ./applications/default.nix
  ];     
  
  config = {
    # userSettings = {
    #   #TO DO
    # }
    
    home.username = userData.username;
    home.homeDirectory = "/home/"+userData.username;

    # Enable xwayland desktop entries for brave, chromium and telegram-desktop.
    # Set to false to disable at once, or override individually.
    applications.xwayland.enable = true;

    # Unlock KeepassXC vault via kwallet desktop entry.
    applications.keepassxc-unlock.enable = true;
      
    xdg.enable = true;

    home.packages = with pkgs; [
      # user packages
    ];
    home.sessionVariables = {
      EDITOR = "vim";
    };
  };
}
