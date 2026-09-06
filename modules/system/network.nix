{ config, lib, pkgs, init, ... }:
{
  config = {
    # Enable networking
    networking.networkmanager.enable = true;
    networking.hostName = init.hostname;
    networking.defaultGateway = config.systemSettings.defaultGateway;
    networking.nameservers = config.systemSettings.dnsServers;
    networking.interfaces.enp6s0.ipv4.addresses = lib.mkIf config.systemSettings.staticIp.enable [
      {
        address = config.systemSettings.staticIp.address;
        prefixLength = config.systemSettings.staticIp.prefixLength;
      }
    ];
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };
}