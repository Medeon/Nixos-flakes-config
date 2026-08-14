# plain Nix file with host metadata — read by the flake before nixosSystem is called.
{
  sysAdmin  = "ejan";
  system    = "x86_64-linux";
  timezone  = "Europe/Amsterdam";
  locale    = "nl_NL.UTF-8";
  keyLayout = "nl";
  keyMap    = "us";
}
