{ config, init, privateData, ... }:
{
  imports = [
    ../../modules/system/default.nix
  ];
  
  config = {
    #TODO: Define a user account. Don't forget to set a password with 'passwd'.
    #TODO: sops.secrets."user/USER/password".neededForUsers = true;
    
    users.users.USER = {
      isNormalUser = true;
      createHome = true;
      description = privateData.users.USER.fullname;
      #TODO: hashedPasswordFile = config.sops.secrets."user/USER/password".path;
      extraGroups = [ "networkmanager" "wheel" ];
    };
    
    # For more information on these options consult: /modules/system/options.nix
    systemSettings = {
      flakeDir = "/home/${init.sysAdmin}/.dotfiles/nixos";
      defaultGateway = privateData.network.defaultGateway; #TODO: edit hosts/minimalDefault/private-data/network.json
      dnsServers = privateData.network.dnsServers; #TODO: edit hosts/minimalDefault/private-data/network.json
      ssh.enable = true; 
      nh.enable = true;
    };
  };
}
