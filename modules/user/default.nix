{ pkgs, ... }:
{
  imports = [
    ./flatpaks.nix
    ./git.nix
    ./home.nix
    ./programs.nix
    ./services.nix
    ./sh.nix
    ./sops.nix
    ./ssh.nix
    ./vim.nix
  ];
}
