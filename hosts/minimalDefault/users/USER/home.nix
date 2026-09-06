{ config, pkgs, lib, ... }:
{
  imports = [
    ../../../../modules/user/default.nix
    ./applications/default.nix
    ./settings/default.nix
  ];

  config = {
    userSettings = {
      username = "USER";
      fullname = privateData.users.USER.fullname;
      email = privateData.users.USER.email;
      git.enable = true;
      vim.enable = true;
      gpg.enable = true;
      gpg.pinentryProgram = pkgs.pinentry-curses;
    };
    home.homeDirectory = "/home/USER";

    xdg.enable = true;
  };
}    