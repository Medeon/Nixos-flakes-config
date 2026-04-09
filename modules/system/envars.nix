{ pkgs, userSettings, ... }:
let 
  username= userSettings.username;
in {
  environment.sessionVariables = {
    NH_FLAKE = "/home/${username}/.dotfiles/nixos";
    PINENTRY_KDE_USE_WALLET = "1";
  };
}
