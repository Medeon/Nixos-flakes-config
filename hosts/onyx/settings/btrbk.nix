{ config, pkgs, lib, privateData, ... }:
let
  commonSettings = {
    transaction_log    = "/var/log/btrbk.log";
    stream_buffer      = "256m";
    timestamp_format   = "long";
    snapshot_dir       = "/btrfs-toplvl/@home-snapshots/btrbk_snapshots";
    snapshot_preserve_min = "3h";
    snapshot_preserve     = "4h 3d";
    preserve_day_of_week  = "monday";
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
    instances."btrbk" = {
      onCalendar   = "daily";
      snapshotOnly = true;
      settings     = commonSettings // {
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
      settings   = commonSettings // {
        ssh_identity = "/var/lib/btrbk/.ssh/id_btrbk_key";
        ssh_user     = "btrbk";
        ssh_port        = toString privateData.ssh.ubuntu.port;
        stream_compress = "zstd";
        target_preserve_min = "3h";
        target_preserve     = "24h 7d 1m";
        volume."/btrfs-toplvl" = {
          subvolume."@home" = {
            snapshot_create = "no";
            target = "ssh://${privateData.ssh.ubuntu."ip-address"}/btrfs-toplvl/@backup/btrbk/nixos";
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
    btrbk-btrbk = {
      after  = [ "sops-install-secrets.service" ];
    };
  };
     
  # Common btrbk root directory rules
  systemd.tmpfiles.rules = [
    "d /btrfs-toplvl/@home-snapshots/btrbk_snapshots 0755 root root"
    "f /var/log/btrbk.log 0640 btrbk btrbk"
  ];
}
