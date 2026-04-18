{ config, lib, pkgs, ... }:
{
  options.applications.keepassxc-unlock.enable =
    lib.mkEnableOption "keepassxc-unlock desktop entry";

  config = lib.mkIf config.applications.keepassxc-unlock.enable {
    xdg.desktopEntries.keepassxc-unlock = {
      name    = "Keepass-unlock";
      comment = "Unlock your KeepassXC vault";
      exec    = "kwallet-query -r KeepassXC kdewallet | keepassxc --pw-stdin ~/.local/share/keepassxc/passwords.kdbx";
      icon    = "keepassxc-unlocked.svg";
    };
  };
}
