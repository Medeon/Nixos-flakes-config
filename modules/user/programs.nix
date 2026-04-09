{ pkgs, ... }:
{
  programs = {
    command-not-found.enable = true;
    gpg.enable = true;
    home-manager.enable = true;
    htop.enable = true;
  };  
}
