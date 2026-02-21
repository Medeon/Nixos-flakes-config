{ config, pkgs, lib, ... }:
{
  imports = [
    ./apps.nix
    ./envars.nix
    ./fonts.nix
    ./fsmounts.nix
    ./pam.nix
    ./programs.nix
    ./services.nix
    ./ssh.nix
    ./sudo.nix
    ./systemd.nix
  ];
}
