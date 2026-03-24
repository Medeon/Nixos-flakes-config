{ pkgs, ... }:
let 
  myAliases = {
    ll = "ls -la";
    sapps = "vim ~/.dotfiles/nixos/modules/system/apps.nix";
    apps = "vim ~/.dotfiles/nixos/modules/user/apps.nix";
    flake = "vim ~/.dotfiles/nixos/flake.nix";
    home = "vim ~/.dotfiles/nixos/home.nix";
    config = "vim ~/.dotfiles/nixos/configuration.nix";
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
