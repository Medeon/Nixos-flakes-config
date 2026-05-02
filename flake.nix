{

  description = "flake";

  inputs = {
      
    nixpkgs.url = "nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    
    home-manager = {
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
    # --------------------------- PRIVATE REPOSITORY --------------------------- #
    mysecrets = {
      url = "git+ssh://git@gitlab.com/ejandev/nix-secrets.git?ref=main&shallow=1";
      flake = false;
    };
  };

  outputs = { self, ... }@inputs:
    let
      lib = inputs.nixpkgs.lib;

      overlays = [
        (import ./overlays/psd-brave.nix)
      ];

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
          userData  = init.users.${primaryUser} // { username = primaryUser; };
          hostSpecs = {
            inherit (init) timezone locale keyLayout keyMap;
            hostname = host;
          };
          pkgs-unstable = import inputs.nixpkgs-unstable {
            inherit system;
            config.allowUnfree = true;
          };
        in
        lib.nixosSystem {
          inherit system;
          modules = [
            (./hosts + "/${host}")
            inputs.home-manager.nixosModules.home-manager
            inputs.nix-snapd.nixosModules.default
            inputs.sops-nix.nixosModules.sops
            inputs.nix-index-database.nixosModules.default
            {
              networking.hostName = host;
              services.snap.enable = true;
              nixpkgs.config.allowUnfree = true;
              nixpkgs.overlays = overlays;
              home-manager = {
                users.${primaryUser} = import (./hosts + "/${host}/home.nix");
                extraSpecialArgs = {
                  inherit inputs userData pkgs-unstable;
                };
                sharedModules = [
                  inputs.sops-nix.homeManagerModules.sops
                  inputs.flatpaks.homeModules.default
                ];
              };
            }
          ];
          specialArgs = {
            inherit inputs pkgs-unstable hostSpecs userData;
          };
        };

    in
    {
      # One nixosConfiguration per host directory, named after the host.
      nixosConfigurations = builtins.listToAttrs (
        map (host: { name = host; value = mkHost host; }) hostNames
      );
    };
}
