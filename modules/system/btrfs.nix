{ config, pkgs, lib, userSettings, ... }:
{
  options.mySystem.btrfs.enable = lib.mkEnableOption "btrfs filesystem mounts";

  config = lib.mkIf config.mySystem.btrfs.enable {
    fileSystems = let
      username = userSettings.username;
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
      "/home/${username}/.dotfiles" = {
        inherit fsType device;
        options = opts ++ [ "subvol=@home/${username}/.dotfiles" ];
      };
      "/home/${username}/Muziek" = {
        inherit fsType device;
        options = opts ++ [ "subvol=@home/${username}/Muziek" ];
      };
      "/home/${username}/.pki" = {
        device = "/home/${username}/.dotfiles/.pki";
        options = [ "bind" ];
      };
      "/home/${username}/.cache" = {
        device = "/home/${username}/.dotfiles/.cache";
        options = [ "bind" ];
      };
      "/home/${username}/.var" = {
        device = "/home/${username}/.dotfiles/.var";
        options = [ "bind" ];
      };
    };
  };
}
