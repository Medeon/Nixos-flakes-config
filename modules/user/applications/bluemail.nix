{ config, lib, pkgs, ... }:
{
  options.applications.bluemail.enable = lib.mkEnableOption "bluemail desktop entry" // { default = true; };

  config = lib.mkIf config.applications.bluemail.enable {
    xdg.desktopEntries.bluemail = {
      name = "BlueMail";
      exec = "bluemail --disable-gpu-sandbox";
      icon = "${pkgs.bluemail}/share/icons/hicolor/1024x1024/apps/bluemail.png";
      comment = "BlueMail email client";
      categories = [ "Office" ];
      mimeType = [
        "x-scheme-handler/me.blueone.linux"
        "x-scheme-handler/mailto"
      ];
      settings = {
        StartupWMClass = "BlueMail";
      };
    };
  };
}
