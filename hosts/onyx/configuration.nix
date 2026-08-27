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
      kde = {
        enable = true;
        wayland = true;
      };
      ssh.enable = true;
      x11.enable = false;
      yubikey.enable = true;
      pipewire.enable = true;
      flatpak.enable = true;
      bluetooth.enable = true;
      nh.enable = true;
      snap.enable = true;
    };
    services.printing.enable = true;
    services.avahi.enable = true;
    services.avahi.nssmdns4 = true;
  };
}
