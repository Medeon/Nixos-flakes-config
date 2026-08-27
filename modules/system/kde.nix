{ config, lib, pkgs, init, ... }:
{
  config = lib.mkIf config.systemSettings.kde.enable {

    # Enable the KDE Desktop environment.
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = config.systemSettings.kde.wayland;
    services.desktopManager.plasma6.enable = true;

    programs.kdeconnect.enable = true;

    environment.systemPackages = with pkgs; [
      kdePackages.dolphin-plugins
      kdePackages.elisa
      kdePackages.francis
      kdePackages.kalarm
      kdePackages.kalk
      kdePackages.kate
      kdePackages.kcolorchooser
      kdePackages.kdeconnect-kde
      kdePackages.kdeplasma-addons
      kdePackages.kfind
      kdePackages.kgamma
      kdePackages.kget
      kdePackages.kde-gtk-config
      kdePackages.kde-inotify-survey
      kdePackages.kdesdk-thumbnailers
      kdePackages.kimagemapeditor
      kdePackages.kjournald
      kdePackages.kdenlive
      kdePackages.kolourpaint
      kdePackages.krecorder
      kdePackages.ksshaskpass
      kdePackages.ksystemlog
      kdePackages.ktorrent
      kdePackages.partitionmanager
      kdePackages.skanlite
      kdePackages.skanpage
      krita
      maliit-keyboard
      materia-kde-theme
    ];
  };
}
