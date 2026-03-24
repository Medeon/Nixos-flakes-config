{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    includes = [
      { path = "~/.config/git/identity"; } #declared in /modules/user/sops.nix
    ];
    settings = {
      init.defaultBranch = "main";
    };
  };
}
