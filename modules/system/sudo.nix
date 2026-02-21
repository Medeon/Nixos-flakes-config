{ config, pkgs, ... }:
{
  #security.sudo = {
   # enable = true;
    #wheelNeedsPassword = false; # Allows wheel group to use sudo without password
    # extraRules = [
    #   {
    #     users = [ "ejan" ];
    #     commands = [
    #       {
    #         command = "/run/current-system/sw/bin/psd-overlay-helper";
    #         options = [ "NOPASSWD" ];
    #       }
    #     ];
    #   }
    # ];
  };
}
