{ config, pkgs, ... }:
{
  environment.sessionVariables = {
    NH_FLAKE = "/home/ejan/.dotfiles/nixos";
  };
}
