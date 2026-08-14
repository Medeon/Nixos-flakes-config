{ config, pkgs, ... }: {

  services.openssh.enable = true;

  programs.ssh = {
    startAgent = false;
    enableAskPassword = true;
  };

  environment.variables = {
    SSH_ASKPASS_REQUIRE = "prefer";
  };
  
  environment.systemPackages = [
    pkgs.openssh
    pkgs.sshfs
    pkgs.sshpass
  ];  
}
