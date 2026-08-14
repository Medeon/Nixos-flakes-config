{ config, pkgs, pkgs-unstable, lib, init, inputs, privateData, ... }:
{
  imports = [
    ../../modules/system/default.nix
    ./applications/default.nix
  ];
  
  config = {
    # For more information on these options consult: /modules/system/options.nix
    systemSettings = {
      flakeDir = "/home/${init.sysAdmin}/.dotfiles/nixos";
      gpuDriver = "amdgpu";
      defaultGateway = privateData.network.defaultGateway;
      staticIp = privateData.network.staticIp;
      dnsServers = privateData.network.dnsServers;
    };
    
    # Enable the X11 windowing system.
    services.xserver.enable = true;
    services.xserver.videoDrivers = [ "${config.systemSettings.gpuDriver}" ];
    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;
    services.printing.enable = true;
    services.avahi.enable = true;
    services.avahi.nssmdns4 = true;

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
    hardware.bluetooth.enable = true;
  };
}
