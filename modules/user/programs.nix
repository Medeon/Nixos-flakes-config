{ pkgs, ... }:
{
  programs = {
    command-not-found.enable = true;
    gpg.enable = true;
    htop.enable = true;
  };  
}
