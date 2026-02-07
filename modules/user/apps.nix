{ config, pkgs, lib, ... }:
{
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    bluemail
    brave
    kdePackages.kate
    kdePackages.kdenlive
    keepassxc
    tree
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
  ];
  xdg.desktopEntries.bluemail = {
    name = "BlueMail";
    exec = "bluemail --disable-gpu-sandbox";
    icon = "${pkgs.bluemail}/share/icons/hicolor/1024x1024/apps/bluemail.png";
    categories = [ "Office" ];
  };
}
