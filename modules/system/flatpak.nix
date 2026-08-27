{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.systemSettings.flatpak.enable {
    services.flatpak = {
      enable = true;
      remotes = {
        "flathub" = "https://dl.flathub.org/repo/flathub.flatpakrepo";
        "flathub-beta" = "https://dl.flathub.org/beta-repo/flathub-beta.flatpakrepo";
      };
    };
    environment.systemPackages = [
      pkgs.npins
    ];
  };
}
