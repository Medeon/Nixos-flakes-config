{ config, pkgs, lib, ... }:
{
  fileSystems = let
    opts = [
      "rw"
      "noatime"
      "ssd"
      "space_cache=v2"
      "discard=async"
      "compress-force=zstd:1"
      "commit=120"
    ];
    fsType = "btrfs";
    device = "/dev/disk/by-uuid/a94905d3-ebd3-4c87-a297-70d53cd25079";
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
    "/home/ejan/.dotfiles" = {
      inherit fsType device;
      options = opts ++ [ "subvol=@home/ejan/.dotfiles" ];
    };
    "/home/ejan/Muziek" = {
      inherit fsType device;
      options = opts ++ [ "subvol=@home/ejan/Muziek" ];
    };
    "/home/ejan/.pki" = {
      device = "/home/ejan/.dotfiles/.pki";
      options = [ "bind" ];
    };
    "/home/ejan/.cache" = {
      device = "/home/ejan/.dotfiles/.cache";
      options = [ "bind" ];
    };
    "/home/ejan/.var" = {
      device = "/home/ejan/.dotfiles/.var";
      options = [ "bind" ];
    };
  };
}
