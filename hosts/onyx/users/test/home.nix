{ config, pkgs, lib, osConfig, ... }:
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