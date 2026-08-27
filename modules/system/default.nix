{ config, pkgs, ... }:
{
  imports = [
    ./bluetooth.nix
    ./configuration.nix
    ./env.nix
    ./flatpak.nix
    ./fonts.nix
    ./kde.nix
    ./network.nix
    ./nh.nix
    ./options.nix
    ./pipewire.nix
    ./snap.nix
    ./ssh.nix
    ./sudo.nix
    ./systemd.nix
    ./x11.nix
    ./yubikey.nix
  ];
}
