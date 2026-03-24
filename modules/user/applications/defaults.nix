{ config, lib, pkgs, ... }:
{
  imports = [
    ./bluemail.nix
    ./brave.nix
    ./chromium.nix
    ./telegram-desktop.nix
  ];

  options.applications.xwayland.enable = lib.mkEnableOption "xwayland desktop entries";

  config = {
    applications.brave.enable = lib.mkDefault config.applications.xwayland.enable;
    applications.chromium.enable = lib.mkDefault config.applications.xwayland.enable;
    applications.telegram-desktop.enable = lib.mkDefault config.applications.xwayland.enable;
  };
}
