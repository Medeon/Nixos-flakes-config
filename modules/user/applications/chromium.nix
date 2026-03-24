{ config, lib, pkgs, ... }:
{
  options.applications.chromium.enable = lib.mkEnableOption "chromium xwayland desktop entry";

  config = lib.mkIf config.applications.chromium.enable {
    xdg.desktopEntries.chromium-browser = {
      name = "Chromium";
      genericName = "Web Browser";
      exec = "chromium --ozone-platform=x11 %U";
      icon = "chromium";
      terminal = false;
      categories = [ "Network" "WebBrowser" ];
      mimeType = [
        "application/pdf"
        "application/rdf+xml"
        "application/rss+xml"
        "application/xhtml+xml"
        "application/xhtml_xml"
        "application/xml"
        "image/gif"
        "image/jpeg"
        "image/png"
        "image/webp"
        "text/html"
        "text/xml"
        "x-scheme-handler/http"
        "x-scheme-handler/https"
        "x-scheme-handler/chromium"
      ];
      settings = {
        StartupWMClass = "chromium-browser";
      };
      actions = {
        new-window = {
          name = "New Window";
          exec = "chromium --ozone-platform=x11";
        };
        new-private-window = {
          name = "New Incognito Window";
          exec = "chromium --ozone-platform=x11 --incognito";
        };
      };
    };
  };
}
