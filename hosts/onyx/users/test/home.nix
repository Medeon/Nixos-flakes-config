{ config, pkgs, ... }:
{
  imports = [
    ../../../../modules/user/default.nix
  ];

  config = {
    userSettings = {
      username = "test";
    };
  };
}    