{ pkgs, ... }:
{
  imports = [
    ./applications/defaults.nix
    ./apps.nix
    ./flatpaks.nix
    ./git.nix
    ./programs.nix
    ./services.nix
    ./sh.nix
    ./sops.nix
    ./ssh.nix
    ./vim.nix
  ];
}
