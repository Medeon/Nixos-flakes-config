{ config, lib, ... }:
{
  config = lib.mkIf config.systemSettings.bluetooth.enable {
    hardware.bluetooth.enable = true;
  };
}
