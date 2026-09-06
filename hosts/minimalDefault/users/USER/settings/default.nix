{ config, osConfig, inputs, ... }:
{
  imports = [
    ./sh.nix
    ./sops.nix
  ];
}