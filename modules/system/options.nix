{ config, lib, ... }:
{
  options = {
    systemSettings = {
      flakeDir = lib.mkOption {
        type = lib.types.str;
        description = "Path to the NixOS flake directory.";
      };

      gpuDriver = lib.mkOption {
        type = lib.types.str;
        description = "Pick your video driver Kernel Module.";
      };

      staticIp = lib.mkOption {
        type = lib.types.str;
        description = "Static IP address for the primary network interface.";
      };

      defaultGateway = lib.mkOption {
        type = lib.types.str;
        description = "Default gateway for the primary network interface.";
      };

      dnsServers = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "DNS servers for the primary network interface.";
      };
    };
    
    # Utility functions and derived defaults shared across system modules.
    # Do not reuse these settings in the host configuration.nix!
    defaultSettings = {
      admins = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        description = "Usernames of administrators (users in the wheel group).";
        default = builtins.filter
          (u: builtins.elem "wheel" (config.users.users.${u}.extraGroups or []))
          (builtins.attrNames config.users.users);
      };
    };
  };
}
