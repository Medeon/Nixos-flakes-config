{ config, pkgs, lib, privateData, ... }:
let
  hostname = privateData.ssh.ubuntu."ip-address";
  port = toString privateData.ssh.ubuntu.port;
  
  snapshotSettings = {
    transaction_log    = "/var/log/btrbk.log";
    stream_buffer      = "256m";
    timestamp_format   = "long";
    snapshot_dir       = "/btrfs-toplvl/@home-snapshots/btrbk_snapshots";
    snapshot_preserve_min = "3h";
    snapshot_preserve     = "4h 3d";
    preserve_day_of_week  = "monday";
  };

  backupSettings = {
    ssh_identity        = "/var/lib/btrbk/.ssh/id_btrbk_key";
    ssh_user            = "btrbk";
    stream_compress     = "zstd";
    target_preserve_min = "3h";
    target_preserve     = "24h 7d 1m";
  };
in 
{
  services.btrbk = {
    sshAccess = [
      {
        key   = config.sops.secrets."keys/ssh/btrbk/id_btrbk_key/private_key".path;
        roles = [ "target" "receive" "send" ];
      }
    ];

    # Runs btrbk snapshot 
    instances."snapshot" = {
      onCalendar   = "daily";
      snapshotOnly = true;
      settings     = snapshotSettings // {
        volume."/btrfs-toplvl" = {
          subvolume."@home" = {
            snapshot_create = "always";
          };
        };
      };
    };
    
    # Runs btrbk backup 
    instances."backup" = {
      onCalendar = "daily";
      settings   = snapshotSettings // backupSettings // {
        volume."/btrfs-toplvl" = {
          subvolume."@home" = {
            snapshot_create = "no";
            target = "ssh://${hostname}:${port}/btrfs-toplvl/@backup/btrbk/nixos";
          };
        };
      };
    };

    # Combined instance for manual on-demand runs and unified list inspection.
    instances."btrbk" = {
      onCalendar = null;
      settings   = snapshotSettings // backupSettings // {
        volume."/btrfs-toplvl" = {
          subvolume."@home" = {
            snapshot_create = "always";
            target = "ssh://${hostname}:${port}/btrfs-toplvl/@backup/btrbk/nixos";
          };
        };
      };
    };
  };
  
  systemd.services = {
    btrbk-backup = {
      after  = [ "sops-install-secrets.service" "network-online.target" ];
      wants  = [ "network-online.target" ];
    };
    btrbk-snapshot = {
      after  = [ "sops-install-secrets.service" ];
    };
  };
     
  # Common btrbk root directory rules
  systemd.tmpfiles.rules = [
    "d /btrfs-toplvl/@home-snapshots/btrbk_snapshots 0755 root root"
    "f /var/log/btrbk.log 0640 btrbk btrbk"
  ];
}
