{ config, lib, pkgs, userData, ... }:
let
  keepassxc-unlock-script = pkgs.writeShellScript "keepassxc-unlock" ''
    ${pkgs.kdePackages.kwallet}/bin/kwallet-query -r KeepassXC kdewallet | \
      ${pkgs.keepassxc}/bin/keepassxc --pw-stdin /home/${userData.username}/.local/share/keepassxc/Passwords.kdbx
  '';
in
{
  options.applications.keepassxc-unlock.enable =
    lib.mkEnableOption "keepassxc-unlock desktop entry";

  config = lib.mkIf config.applications.keepassxc-unlock.enable {
    xdg.desktopEntries.keepassxc-unlock = {
      name    = "Keepass-unlock";
      comment = "Unlock your KeepassXC vault";
      exec    = "${keepassxc-unlock-script}";
      icon    = "keepassxc-unlocked";
    };
  };
}
