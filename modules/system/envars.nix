{ config, pkgs, pkgs-unstable, ... }:
{
  environment.sessionVariables = {
    NH_FLAKE = "/home/ejan/.dotfiles/nixos";
  };
}
