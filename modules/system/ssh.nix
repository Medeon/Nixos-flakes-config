{ config, pkgs, userSettings, ... }: {

  sops.templates."btrbk-ubuntu-ssh" = {
    path = "/var/lib/btrbk/.ssh/config";
    owner = "btrbk";
    group = "btrbk";
    mode = "0600";
    content = ''
      Host btrbk-ubuntu
        Hostname ${config.sops.placeholder."ssh/ubuntu/ip-address"}
        User btrbk
        Port ${config.sops.placeholder."ssh/ubuntu/port"}
        IdentitiesOnly yes
        IdentityFile /var/lib/btrbk/.ssh/id_btrbk_key
    '';
  };

  programs.ssh = {
    startAgent = false;
    enableAskPassword = true;
  };

  environment.variables = {
    SSH_ASKPASS_REQUIRE = "prefer";
  };
}
