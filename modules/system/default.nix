{ config, pkgs, ... }:
{
  imports = [
    ./configuration.nix
    ./flatpak.nix
    ./fonts.nix
    ./kde.nix
    ./network.nix
    ./nh.nix
    ./options.nix
    ./snap.nix
    ./ssh.nix
    ./sudo.nix
    ./systemd.nix
    ./yubikey.nix
  ];
}
