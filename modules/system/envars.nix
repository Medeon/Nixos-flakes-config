{ pkgs, userData, ... }:
let 
  username= userData.username;
in {
  environment.sessionVariables = {
    NH_FLAKE = "/home/${username}/.dotfiles/nixos";
    PINENTRY_KDE_USE_WALLET = "1";
  };
}
