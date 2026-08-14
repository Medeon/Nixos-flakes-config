{ config, lib, pkgs, ... }:
{
  imports = [
    ./sh.nix
    ./sops.nix
    ./ssh.nix
  ];
}