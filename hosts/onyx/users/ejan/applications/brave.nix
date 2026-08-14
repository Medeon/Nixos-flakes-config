{ config, lib, pkgs, ... }:
{
  options.applications.brave.enable = lib.mkEnableOption "brave xwayland desktop entry";

  config = lib.mkIf config.applications.brave.enable {
    xdg.desktopEntries.brave-browser = {
      name = "Brave Web Browser";
      genericName = "Web Browser";
      exec = "brave --ozone-platform=x11 %U";
      icon = "brave-browser";
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
        "Name[nl]" = "Brave webbrowser";
        "GenericName[nl]" = "Webbrowser";
      };
      actions = {
        new-window = {
          name = "New Window";
          exec = "brave --ozone-platform=x11";
        };
        new-private-window = {
          name = "New Incognito Window";
          exec = "brave --ozone-platform=x11 --incognito";
        };
      };
    };
  };
}
