{ config, pkgs, ... }:
{
  imports = [
    ./apps.nix
    ./flatpaks.nix
  ];
}
