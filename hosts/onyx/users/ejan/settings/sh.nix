{ pkgs, osConfig, ... }:
let 
  hostname = osConfig.networking.hostName;
  myAliases = {
    ll = "ls -la";
    apps = "vim ~/.dotfiles/nixos/hosts/${hostname}/applications/apps.nix";
    userapps = "vim ~/.dotfiles/nixos/hosts/${hostname}/users.nix";
    flatpaks = "vim ~/.dotfiles/nixos/hosts/${hostname}/applications/flatpaks.nix"; 
    flake = "vim ~/.dotfiles/nixos/flake.nix";
    home = "vim ~/.dotfiles/nixos/hosts/${hostname}/users/ejan/home.nix";
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
    sessionVariables = {
      PASSWORD_STORE_DIR = "/run/media/ejan/Sec_Backup/.password-store";
    };
  };
}
