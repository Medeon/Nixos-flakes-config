{ config, pkgs, lib, osConfig, inputs, privateData, ... }:
{
  imports = [
    ../../../../modules/user/default.nix
    ./applications/default.nix
    ./settings/default.nix
  ];

  config = {
    userSettings = {
      username = "ejan";
      fullname = privateData.users.ejan.fullname;
      email = privateData.users.ejan.email;
      git.enable = true;
      vim.enable = true;
      psd.enable = true;
      gpg.enable = true;
      gpg.pinentryProgram = pkgs.pinentry-qt;
    };

    home.homeDirectory = "/home/ejan";

    xdg.enable = true;
  };
}
