{ pkgs, config, userSettings, ... }:
{
  sops.templates."ssh-hosts" = {
    path = "/home/${userSettings.username}/.ssh/config.d/sops-hosts";
    content = ''
      Host userver
        Hostname ${config.sops.placeholder."ssh/ubuntu/ip-address"}
        User ${userSettings.username}
        Port ${config.sops.placeholder."ssh/ubuntu/port"}
        IdentitiesOnly yes
        IdentityFile ~/.ssh/id_nixos

      Host windows11
        Hostname ${config.sops.placeholder."ssh/windows/ip-address"}
        User ${config.sops.placeholder."ssh/windows/user"}
        IdentitiesOnly yes
        IdentityFile ~/.ssh/id_ed25519
    '';
  };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    extraConfig = ''
      Include ~/.ssh/config.d/sops-hosts
    '';

    matchBlocks = {
      "*" = {};
      "git-hosts" = {
        host = "github.com gitlab.com";
        user = "git";
        identitiesOnly = true;
        identityFile = "~/.ssh/id_nixos";
      };
    };
  };
}
