{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.userSettings.vim.enable {
    programs.vim = {
      enable = true;
      plugins = with pkgs; [
        vimPlugins.blink-ripgrep-nvim
        vimPlugins.fzf-vim
        vimPlugins.rust-vim 
      ];
      extraConfig = ''
        set number
        filetype plugin indent on
        set expandtab
        set shiftwidth=2
        set softtabstop=2
        set tabstop=2
        set smartindent
        syntax on
      '';
    };
  };
}
