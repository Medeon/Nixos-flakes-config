{ config, lib, pkgs, ... }:
{
  options.applications.telegram-desktop.enable = lib.mkEnableOption "telegram-desktop xwayland desktop entry";

  config = lib.mkIf config.applications.telegram-desktop.enable {
    xdg.desktopEntries."org.telegram.desktop" = {
      name = "Telegram";
      comment = "New era of messaging";
      exec = "env QT_QPA_PLATFORM=xcb Telegram -- %U";
      icon = "org.telegram.desktop";
      terminal = false;
      categories = [ "Chat" "Network" "InstantMessaging" "Qt" ];
      mimeType = [
        "x-scheme-handler/tg"
        "x-scheme-handler/tonsite"
      ];
      settings = {
        StartupWMClass = "TelegramDesktop";
        Keywords = "tg;chat;im;messaging;messenger;sms;tdesktop;";
        DBusActivatable = "true";
        SingleMainWindow = "true";
        X-GNOME-UsesNotifications = "true";
        X-GNOME-SingleWindow = "true";
      };
      actions = {
        quit = {
          name = "Quit Telegram";
          exec = "Telegram -quit";
        };
      };
    };
  };
}
