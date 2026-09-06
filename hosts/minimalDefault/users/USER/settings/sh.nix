{ pkgs, osConfig, ... }:
let 
  hostname = osConfig.networking.hostName;
  myAliases = {
    ll = "ls -la";
    apps = "vim ~/.dotfiles/nixos/hosts/${hostname}/applications/apps.nix";
    myapps = "vim ~/.dotfiles/nixos/hosts/${hostname}/users/USER/applications/apps.nix";
    flake = "vim ~/.dotfiles/nixos/flake.nix";
    home = "vim ~/.dotfiles/nixos/hosts/${hostname}/users/USER/home.nix";
    config = "vim ~/.dotfiles/nixos/hosts/${hostname}/configuration.nix";
    cdnixos = "cd ~/.dotfiles/nixos";
    cdsystem = "cd ~/.dotfiles/nixos/modules/system";
    cduser = "cd ~/.dotfiles/nixos/modules/user";
    jctl = "journalctl -p 3 -xb";
    df = "df -h";
    free = "free -m";
    rm = "rm -i";
  };
in {
  programs.bash = {
    enable = true;
    shellAliases = myAliases;
  };
}
