{ ... }:
{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    ./settings/default.nix
    ./applications/default.nix
  ];

  config.home-manager.users = {
    USER = import ./users/USER/home.nix;
  };
}
