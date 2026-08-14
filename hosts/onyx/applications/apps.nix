{ config, pkgs, pkgs-unstable, lib, ... }:
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = (with pkgs; [
    alsa-utils
    androidenv.androidPkgs.platform-tools
    appstream
    btrfs-assistant
    clinfo
    collision
    edk2-uefi-shell
    ffmpeg_7-full
    file
    fish
    hplip
    mcfly
    neovim
    nvme-cli
    openh264
    pass
    squashfsTools
    xorg.xf86videoamdgpu
    zstd
  ])
  
  ++
  
  (with pkgs-unstable; [
    # 
  ]);
}
