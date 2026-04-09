{ pkgs, ... }:
{
  imports = [
    ./applications/defaults.nix
    ./apps.nix
    ./git.nix
    ./programs.nix
    ./services.nix
    ./sh.nix
    ./sops.nix
    ./ssh.nix
    ./vim.nix
  ];
}
