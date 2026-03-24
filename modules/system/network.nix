{ config, pkgs, ... }:
{
  # NM keyfile profile for the static wired connection on enp6s0.
  # Written via sops template so secrets stay encrypted at rest.
  # NM automatically picks up keyfiles from /etc/NetworkManager/system-connections/.
  sops.templates."enp6s0.nmconnection" = {
    path = "/etc/NetworkManager/system-connections/enp6s0.nmconnection";
    owner = "root";
    group = "root";
    mode = "0600";
    restartUnits = [ "NetworkManager.service" ];
    content = ''
      [connection]
      id=enp6s0
      type=ethernet
      interface-name=enp6s0
      autoconnect=true

      [ethernet]

      [ipv4]
      method=manual
      address1=${config.sops.placeholder."network/ip-address"}/24,${config.sops.placeholder."network/default-gateway"}
      dns=${config.sops.placeholder."network/dns1"};${config.sops.placeholder."network/dns2"};

      [ipv6]
      method=auto
    '';
  };
}
