{ pkgs, ... }:
{
  services = {
    psd = {
      enable = true;
      resyncTimer = "1h";
    };
    gpg-agent = {
      enable = true;
      enableExtraSocket = true;
      enableSshSupport = false;
      maxCacheTtl = 86400;
      pinentry = {
        package = pkgs.pinentry-qt;
      };
      extraConfig = ''
        allow-preset-passphrase
      '';
    };
  };  
}
