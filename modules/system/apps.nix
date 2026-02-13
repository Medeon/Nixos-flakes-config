{ config, pkgs, lib, ... }:
{
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
        appstream
        fd
        file
        git
        gnupg
        neovim
        openssh
        pam_u2f
        pcsclite
        pcsc-tools
        profile-sync-daemon
        ripgrep
        rustdesk
        squashfsTools
        sshfs
        tmux
        trezord
        trezor-suite
        vim
        vimPlugins.blink-ripgrep-nvim
        vimPlugins.fzf-vim
        vimPlugins.rust-vim
        wget
        yubico-pam
        yubikey-manager
        yubikey-personalization
    ];
}
