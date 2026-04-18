{ pkgs, userSettings, ... }:
{
  programs =  {
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 7d --keep 5";
      flake = "${userSettings.flakeDir}";
    };
    kdeconnect.enable = true;
  };
}
