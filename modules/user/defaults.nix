{ pkgs, ... }:
{
  imports = [
    ./applications/defaults.nix
    ./apps.nix
    ./git.nix
    ./services.nix
    ./sh.nix
    ./sops.nix
    ./ssh.nix
    ./vim.nix
  ];
}
