{ config, pkgs, lib, ... }:
{
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
        fd
        git
        gnupg
        neovim
        openssh
        pam_u2f
        pcsclite
        pcsc-tools
        ripgrep
        sshfs
        tmux
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
