{ pkgs, ... }:
{
  imports = [
    ./git.nix
    ./gpg.nix
    ./home.nix
    ./options.nix
    ./psd.nix
    ./vim.nix
  ];
}
