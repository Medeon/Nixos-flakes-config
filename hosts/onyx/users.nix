{ config, pkgs, pkgs-unstable, lib, inputs, privateData, ... }:
{
  config = {
    # Define a user account. Don't forget to set a password with 'passwd'.
    sops.secrets."user/ejan/password".neededForUsers = true;
    
    users.users.ejan = {
      isNormalUser = true;
      createHome = true;
      description = privateData.users.ejan.fullname;
      hashedPasswordFile = config.sops.secrets."user/ejan/password".path;
      extraGroups = [ "networkmanager" "wheel" ];
    };

    users.users.test = {
      isNormalUser = true;
      isSystemUser = false;
      createHome = false;
      description = privateData.users.test.fullname;
      group = "test";
    };
    users.groups.test = {};
  };
}
