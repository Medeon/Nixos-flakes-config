{ config, pkgs, ... }:
{
  imports = [
    ./sh.nix
    ./git.nix
    ./vim.nix
    ./apps.nix
  ];
}
