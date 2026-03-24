{ pkgs, ... }:
{
  environment.sessionVariables = {
    NH_FLAKE = "/home/ejan/.dotfiles/nixos";
    PASSWORD_STORE_DIR = "/media/ejan/Sec_Backup/.password-store";
  };
}
