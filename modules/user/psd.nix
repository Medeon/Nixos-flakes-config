{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.userSettings.psd.enable {
    services.psd = {
      enable = true;
      resyncTimer = "1h";
      browsers = [ ];
    };
  };
}
