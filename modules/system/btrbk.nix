{ config, pkgs, lib, ... }: {
    services.btrbk = {
      sshAccess = [
        {
          key = config.sops.secrets."keys/ssh/btrbk/id_btrbk_key/private_key".path;
          roles = [ "target" "receive" "send" ];
        }
      ];
      instances."btrbk" = {
        onCalendar = "daily";
        settings = {
          transaction_log = "/var/log/btrbk.log";
          stream_buffer = "256m";
          timestamp_format = "long";

          # NOTE: The SSH private key must exist at this path and be readable
          # by the btrbk user/group. Ensure proper ownership/permissions.
          ssh_identity = "/var/lib/btrbk/.ssh/id_btrbk_key";
          ssh_user = "btrbk";
          stream_compress = "zstd";

          snapshot_dir = "/btrfs-toplvl/@home-snapshots/btrbk_snapshots";
          snapshot_preserve_min = "3h";
          snapshot_preserve = "4h 3d";

          target_preserve_min = "3h";
          target_preserve = "24h 7d 1m";
          preserve_day_of_week = "monday";

          volume."/btrfs-toplvl" = {
            subvolume."@home" = {
              snapshot_create = "always";
            };  
            target = "ssh://btrbk-ubuntu/btrfs-toplvl/@backup/btrbk/nixos";
          };
        };
      };
    };  
    systemd.tmpfiles.rules = [
      "d /btrfs-toplvl/@home-snapshots/btrbk_snapshots 0755 root root"
      "f /var/log/btrbk.log 0640 btrbk btrbk"
      "L+ /var/lib/btrbk/.ssh/config - - - - /run/secrets/btrbk-ssh-config"
    ];

    systemd.services.btrbk-btrbk.after = [ "sops-install-secrets.service" ];
  }
