{ pkgs, inputs, privateData, ... }:
{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {};
      "git-hosts" = {
        host = "github.com gitlab.com";
        user = "git";
        identitiesOnly = true;
        identityFile = "~/.ssh/id_nixos";
      };
      "userver" = {
        hostname = privateData.ssh.ubuntu."ip-address";
        user = privateData.ssh.ubuntu.user;
        port = privateData.ssh.ubuntu.port;
        identitiesOnly = true;
        identityFile = "~/.ssh/id_nixos";
      };
      "windows11" = {
        hostname = privateData.ssh.windows11."ip-address";
        user = privateData.ssh.windows11.user;
        identitiesOnly = true;
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };
}
