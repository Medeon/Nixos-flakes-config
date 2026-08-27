{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.systemSettings.yubikey.enable {

    services.udev.packages = with pkgs; [ yubikey-personalization libu2f-host ];
    services.pcscd.enable = true;

    environment.systemPackages = with pkgs; [
      pcsclite
      pcsc-tools
      yubico-pam
      yubikey-manager
      yubikey-personalization
    ];
  };
}
