{ pkgs, userSettings, ... }:
let 
  username= userSettings.username;
in {
  environment.sessionVariables = {
    NH_FLAKE = "/home/${username}/.dotfiles/nixos";
    PASSWORD_STORE_DIR = "/media/${username}/Sec_Backup/.password-store";
  };
}
