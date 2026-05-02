{ pkgs, userData, ... }:
{
  programs =  {
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 7d --keep 5";
      flake = "${userData.flakeDir}";
    };
    kdeconnect.enable = true;
  };
}
