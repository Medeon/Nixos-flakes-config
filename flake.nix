{

  description = "flake";

  inputs = {
  
    # nixos nixpkgs github repository 
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    
    home-manager = {
      # home-manager github repository
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nix-snapd.url = "github:nix-community/nix-snapd";
    nix-snapd.inputs.nixpkgs.follows = "nixpkgs";
    
    flatpaks.url = "github:in-a-dil-emma/declarative-flatpak/latest";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # ------------------- PRIVATE REPOSITORY ------------------- #
    mysecrets = {
      url = "git+ssh://git@gitlab.com/ejandev/nix-secrets.git?ref=main&shallow=1";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager,
              nix-snapd, flatpaks, sops-nix, nix-index-database, ... }@inputs:
    let
      lib = nixpkgs.lib;

      overlays = [
        (import ./overlays/psd-brave.nix)
      ];

      # Build a pkgs set for a given system
      pkgsFor = system: import nixpkgs {
        inherit system overlays;
        config.allowUnfree = true;
      };

      pkgsUnstableFor = system: import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      # -------------------------------------------------------
      # Host discovery — every sub-directory in ./hosts is a host.
      # Each host must contain a init.nix (plain attribute set) with:
      #
      #   { system, timezone, locale, keyLayout, keyMap, users }
      #
      # See hosts/onyx/init.nix for an example.
      # -------------------------------------------------------
      hostNames = builtins.filter
        (name: (builtins.readDir ./hosts).${name} == "directory")
        (builtins.attrNames (builtins.readDir ./hosts));

      hostInit = host: import (./hosts + "/${host}/init.nix");

      # Build a NixOS configuration for a single host.
      mkHost = host:
        let
          init           = hostInit host;
          system         = init.system;
          primaryUser    = lib.head (lib.attrNames init.users);
          userSettings   = init.users.${primaryUser} // { username = primaryUser; };
          systemSettings = {
            inherit (init) timezone locale keyLayout keyMap;
            hostname = host;
          };
        in
        lib.nixosSystem {
          inherit system;
          modules = [
            (./hosts + "/${host}")
            nix-snapd.nixosModules.default
            sops-nix.nixosModules.sops
            nix-index-database.nixosModules.default
            {
              networking.hostName = host;
              services.snap.enable = true;
              nixpkgs.config.allowUnfree = true;
              nixpkgs.overlays = overlays;
            }
          ];
          specialArgs = {
            inherit inputs systemSettings userSettings;
            pkgs-unstable = pkgsUnstableFor system;
          };
        };

      # Build a standalone Home Manager configuration for a single user on a host.
      mkHome = host: user:
        let
          init         = hostInit host;
          system       = init.system;
          userSettings = init.users.${user} // { username = user; };
        in
        home-manager.lib.homeManagerConfiguration {
          pkgs = pkgsFor system;
          modules = [
            (./hosts + "/${host}/home.nix")
            sops-nix.homeManagerModules.sops
            flatpaks.homeModules.default
          ];
          extraSpecialArgs = {
            inherit inputs userSettings;
            pkgs-unstable = pkgsUnstableFor system;
          };
        };

    in
    {
      # One nixosConfiguration per host directory, named after the host.
      nixosConfigurations = builtins.listToAttrs (
        map (host: { name = host; value = mkHost host; }) hostNames
      );

      # One homeConfiguration per user per host, addressed as "user@host".
      homeConfigurations = lib.foldl'
        (acc: host:
          let init = hostInit host;
          in acc // lib.mapAttrs'
            (user: _: lib.nameValuePair "${user}@${host}" (mkHome host user))
            init.users
        )
        {}
        hostNames;
    };
}
