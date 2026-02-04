{ config, lib, pkgs, ... }:
{
  programs.ssh = {
    startAgent = true;
    enableAskPassword = true;
    extraConfig = "
      Host userver
        Hostname 192.168.1.241
        User ejan
        Port 5588
        IdentitiesOnly yes
        IdentityFile ~/.ssh/id_nixos

      Host windows11
        Hostname 192.168.1.242
        User Evert-Jan
        Port 22
        IdentitiesOnly yes
        IdentityFile ~/.ssh/id_ed25519
    ";
  };

  environment.variables = {
    SSH_ASKPASS_REQUIRE = "prefer";
  };
}
