{ config, pkgs, lib, ... }:
{
  imports = [
    ./apps.nix
    ./envars.nix
    ./fsmounts.nix
    ./pam.nix
    ./programs.nix
    ./services.nix
    ./snapd.nix
    ./ssh.nix
    ./systemd.nix
  ];
}
