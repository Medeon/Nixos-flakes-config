{ config, pkgs, pkgs-unstable, ... }:
{
  config = {
    home.packages = (with pkgs; [
      bluemail
      brave
      chromium
      gimp
      grsync
      inkscape
      keepassxc
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
      vifm-full
      vlc
      yamllint
    ])

    ++

    (with pkgs-unstable; [
      pixelflasher
    ]);
    # Enable xwayland desktop entries for brave, chromium and telegram-desktop.
    applications.xwayland.enable = true;

    # Unlock KeepassXC vault via kwallet desktop entry.
    applications.keepassxc-unlock.enable = true;
  };
}