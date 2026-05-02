Every sub-directory in ./hosts is a host.
Each host must contain a init.nix (plain attribute set) with:

{ system, timezone, locale, keyLayout, keyMap, users }

See hosts/onyx/init.nix for an example.
