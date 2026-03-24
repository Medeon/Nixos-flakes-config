{ config, pkgs, ... }:
{
  sops.templates."10-static.network" = {
    path = "/etc/systemd/network/10-static.network";
    owner = "root";
    group = "systemd-network";
    mode = "0640";
    content = ''
      [Match]
      Name=enp6s0

      [Network]
      Address=${config.sops.placeholder."network/ip-address"}/24
      Gateway=${config.sops.placeholder."network/default-gateway"}
      DNS=${config.sops.placeholder."network/dns1"}
      DNS=${config.sops.placeholder."network/dns2"}
    '';
  };
}
