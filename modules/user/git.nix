{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.userSettings.git.enable {
    programs.git = {
      enable    = true;
      settings  = {
        init.defaultBranch = "main";
        core.symlinks      = false;
        user = {
          name = config.userSettings.fullname;
          email = config.userSettings.email;
        };  
      };
    };
  };
}
