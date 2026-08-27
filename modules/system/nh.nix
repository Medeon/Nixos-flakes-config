{ config, lib, pkgs, ... }:
{
  config = lib.mkIf config.systemSettings.nh.enable {
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 7d --keep 5";
      flake = config.systemSettings.flakeDir;
    };
    environment = {
      systemPackages = with pkgs; [
        nh
      ];
      sessionVariables = {
        NH_FLAKE = config.systemSettings.flakeDir;
      };
    };  
  };
}
