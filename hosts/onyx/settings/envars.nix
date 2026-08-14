{ config, pkgs, ... }:
{
  environment.sessionVariables = {
    NH_FLAKE = config.systemSettings.flakeDir;
  };
}
