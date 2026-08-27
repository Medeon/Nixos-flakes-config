{ config, lib, init, pkgs, ... }:
{
  config = lib.mkIf config.systemSettings.x11.enable {
    # Enable the X11 windowing system.
    services.xserver.enable = true;
    services.xserver.videoDrivers = [ "${config.systemSettings.gpuDriver}" ];
    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;
  };
}
