# Host metadata — read by the flake before nixosSystem is called.
# This is a plain Nix file, not a NixOS module.
{
  system    = "x86_64-linux";
  timezone  = "Europe/Amsterdam";
  locale    = "nl_NL.UTF-8";
  keyLayout = "nl";
  keyMap    = "us";
  users = {
    ejan = {
      fullname = "Evert-Jan";
      flakeDir = "/home/ejan/.dotfiles/nixos";
    };
  };
}
