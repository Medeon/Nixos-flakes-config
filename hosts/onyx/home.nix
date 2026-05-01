{ config, pkgs, lib, userSettings, ... }:
{
  imports = [
    ../../modules/user/defaults.nix
    ../../common/home.nix
  ];     
  
  # config = {
  #   userSettings = {
  #     #TO DO
  #   }

  # };
      
  home.username = userSettings.username;
  home.homeDirectory = "/home/"+userSettings.username;

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

  
}
