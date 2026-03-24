{ config, pkgs, userSettings, ... }: {

  sops.templates."btrbk-ubuntu-ssh" = {
    path = "/etc/ssh/ssh_config.d/btrbk-ubuntu.conf";
    owner = "root";
    group = "btrbk";
    mode = "0640";
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
    extraConfig = ''
      Match User btrbk
        Include /etc/ssh/ssh_config.d/btrbk-ubuntu.conf
    '';
  };

  environment.variables = {
    SSH_ASKPASS_REQUIRE = "prefer";
  };
}
