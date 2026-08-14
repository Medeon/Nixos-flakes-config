{ ... }:
{
  imports = [
    ./configuration.nix
    ./settings/default.nix
    ./applications/default.nix
    ./users.nix
  ];

  config.home-manager.users = {
    ejan = import ./users/ejan/home.nix;
  };
}
