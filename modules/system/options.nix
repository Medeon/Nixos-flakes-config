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

      kde.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable the KDE Plasma desktop environment (manually enable x11 if prefered).";
      };

      kde.wayland = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to use KDE with Wayland (requires kde.enable = true).";
      };

      ssh.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable OpenSSH and related packages.";
      };

      x11.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable the X11 windowing system.";
      };

      yubikey.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable YubiKey udev rules, pcscd, and packages.";
      };

      pipewire.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable PipeWire audio.";
      };

      flatpak.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable Flatpak with Flathub remotes.";
      };

      bluetooth.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable Bluetooth hardware support.";
      };

      nh.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable the Nix Helper (nh) program.";
      };

      snap.enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable Snap (snapd tmpfiles rules).";
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
