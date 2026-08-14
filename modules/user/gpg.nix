{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.userSettings.gpg.enable {
    assertions = [{
      assertion = config.userSettings.gpg.pinentryProgram != null;
      message = "userSettings.gpg.pinentryProgram must be set when userSettings.gpg.enable is true.";
    }];
    programs.gpg.enable = true;
    services.gpg-agent = {
      enable = true;
      enableExtraSocket = true;
      enableSshSupport = false;
      maxCacheTtl = 86400;
      pinentry.package = config.userSettings.gpg.pinentryProgram;
      extraConfig = ''
        allow-preset-passphrase
      '';
    };
  };
}
