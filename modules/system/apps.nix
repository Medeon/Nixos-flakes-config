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
    duf
    fd
    ffmpeg_7-full
    file
    fish
    git
    git-lfs
    hplip
    htop
    mcfly
    neofetch
    neovim
    nh
    nix-output-monitor
    nvd
    nvme-cli
    openh264
    openssh
    kdePackages.kwallet-pam
    pam_gnupg
    pam_u2f
    pass
    pcsclite
    pcsc-tools
    ripgrep
    sops
    squashfsTools
    sshfs
    sshpass
    tmux
    vifm-full
    vim
    vimPlugins.blink-ripgrep-nvim
    vimPlugins.fzf-vim
    vimPlugins.rust-vim
    wget
    xorg.xf86videoamdgpu
    yubico-pam
    yubikey-manager
    yubikey-personalization
    zstd
  ])
  
  ++
  
  (with pkgs-unstable; [
    # 
  ]);  
}
