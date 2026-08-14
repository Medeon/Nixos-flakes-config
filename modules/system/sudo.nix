{ config, pkgs, ... }:
{
  security.sudo = {
    enable = true;
    extraRules = [
      {
        users    = config.defaultSettings.admins;
        commands = [
          {
            command = "${pkgs.profile-sync-daemon}/bin/psd-overlay-helper";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };
}
