{ config, pkgs, ... }:
let 
  myAliases = {
    ll = "ls -la";
    nxr-s = "sudo nixos-rebuild switch --flake ~/.dotfiles/nixos";
    hman-s = "home-manager switch --flake ~/.dotfiles/nixos";
    sysapps = "vim ~/.dotfiles/nixos/modules/system/apps.nix";
    apps = "vim ~/.dotfiles/nixos/modules/user/apps.nix";
    home-man = "vim ~/.dotfiles/nixos/home.nix";
    config = "vim ~/.dotfiles/nixos/configuration.nix";
    cdnixos = "cd ~/.dotfiles/nixos";
    cdsystem = "cd ~/.dotfiles/nixos/modules/system";
    cduser = "cd ~/.dotfiles/nixos/modules/user";
    jctl = "journalctl -p 3 -xb";
    df = "df -h";
    free = "free -m";
    rm = "rm -i";
  };
in  
{
  programs.bash = {
    enable = true;
    shellAliases = myAliases;
  };
}
