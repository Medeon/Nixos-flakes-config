{ config, lib, pkgs, ... }:
{
  imports = [
    ./apps.nix
    ./bluemail.nix
    ./brave.nix
    ./chromium.nix
    ./keepassxc-unlock.nix
    ./telegram-desktop.nix
  ];

  options.applications.xwayland.enable = lib.mkEnableOption "xwayland desktop entries";

  config = {
    applications.brave.enable = lib.mkDefault config.applications.xwayland.enable;
    applications.chromium.enable = lib.mkDefault config.applications.xwayland.enable;
    applications.telegram-desktop.enable = lib.mkDefault config.applications.xwayland.enable;
  };
}
