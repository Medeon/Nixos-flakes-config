{ config, pkgs, lib, ... }:
{
  imports = [
    ./apps.nix
    ./btrbk.nix
    ./envars.nix
    ./fonts.nix
    ./btrfs.nix
    ./pam.nix
    ./programs.nix
    ./services.nix
    ./sops.nix
    ./ssh.nix
    ./sudo.nix
    ./systemd.nix
  ];
}
