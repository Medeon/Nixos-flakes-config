{ pkgs, ... }:
{
  security.sudo = {
    enable = true;
    extraRules = [
      {
        users = [ "ejan" ];
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
