{ config, osConfig, inputs, privateData, ... }:
{
  imports = [
    ./sh.nix
    ./sops.nix
    ./ssh.nix
  ];
}