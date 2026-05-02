{ config, pkgs, lib, ... }:
{
  imports = [
    ./apps.nix
    ./btrbk.nix
    ./configuration.nix
    ./envars.nix
    ./fonts.nix
    ./network.nix
    ./pam.nix
    ./programs.nix
    ./services.nix
    ./sops.nix
    ./ssh.nix
    ./sudo.nix
    ./systemd.nix
  ];
}
