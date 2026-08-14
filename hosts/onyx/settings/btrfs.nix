{ config, pkgs, lib, privateData, ... }:
{
  options.mySystem.btrfs.enable = lib.mkEnableOption "btrfs filesystem mounts";

  config = lib.mkIf config.mySystem.btrfs.enable {
    fileSystems = let
      opts = [
        "rw"
        "noatime"
        "ssd"
        "space_cache=v2"
        "discard=async"
        "compress-force=zstd"
        "commit=120"
      ];
      fsType = "btrfs";
      device = "/dev/disk/by-uuid/a94905d3-ebd3-4c87-a297-70d53cd25079";

      homeUsers = lib.filterAttrs (_: u: u.createHome or false) privateData.users;

      userBtrfsMounts = lib.concatMapAttrs (name: _: {
        "/home/${name}/.dotfiles" = {
          inherit fsType device;
          options = opts ++ [ "subvol=@home/${name}/.dotfiles" ];
        };
        "/home/${name}/Muziek" = {
          inherit fsType device;
          options = opts ++ [ "subvol=@home/${name}/Muziek" ];
        };
      }) homeUsers;

      userBindMounts = lib.concatMapAttrs (name: _: {
        "/home/${name}/.pki" = {
          device = "/home/${name}/.dotfiles/.pki";
          options = [ "bind" ];
        };
        "/home/${name}/.cache" = {
          device = "/home/${name}/.dotfiles/.cache";
          options = [ "bind" ];
        };
        "/home/${name}/.var" = {
          device = "/home/${name}/.dotfiles/.var";
          options = [ "bind" ];
        };
      }) homeUsers;

    in {
      "/" = {
        inherit fsType device;
        options = opts ++ [ "subvol=@" ];
      };
      "/btrfs-toplvl" = {
        inherit fsType device;
        options = opts ++ [ "subvolid=5" ];
      };
      "/home" = {
        inherit fsType device;
        options = opts ++ [ "subvol=@home" ];
      };
      "/.snapshots" = {
        inherit fsType device;
        options = opts ++ [ "subvol=@snapshots" ];
      };
      "/var/log" = {
        inherit fsType device;
        options = opts ++ [ "subvol=@log" ];
        neededForBoot = true;
      };
      "/var/cache" = {
        inherit fsType device;
        options = opts ++ [ "subvol=@cache" ];
      };
      "/swap" = {
        inherit fsType device;
        options = [ "noatime" "nodatacow" "subvol=@swap" ];
      };
      "/home/.snapshots" = {
        inherit fsType device;
        options = opts ++ [ "subvol=@home-snapshots" ];
      };
    } // userBtrfsMounts // userBindMounts;
  };
}
