{ pkgs, pkgs-unstable, ... }:
{
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = (with pkgs; [
    bluemail
    brave
    chromium
    gimp
    grsync
    inkscape
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
    keepassxc
    krita
    maliit-keyboard
    materia-kde-theme
    monero-gui
    nextcloud-client
    obs-studio
    onlyoffice-desktopeditors
    opencode
    rustdesk
    telegram-desktop
    tree
    trezord
    trezor-suite
    variety
    vscodium
    vlc
    yamllint
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ])

  ++

  (with pkgs-unstable; [
    pixelflasher  
  ]);

}
