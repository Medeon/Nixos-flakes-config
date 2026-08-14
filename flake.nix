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
    # --------------------------- PRIVATE REPOSITORY -------------------------- #
    mysecrets = {
      url = "git+ssh://git@gitlab.com/ejandev/nix-secrets.git?ref=main&shallow=1";
      flake = false;
    };
  };

  outputs = { self, ... }@inputs:
    let
      lib          = inputs.nixpkgs.lib;
      overlays = [
        (import ./overlays/psd-brave.nix)
      ];
      
      fromJsonFile = path: builtins.fromJSON (builtins.readFile path);

      mkPrivateData = host:
        let base = "${self}/hosts/${host}/private-data";
        in {
          users   = fromJsonFile "${base}/users.json";
          network = fromJsonFile "${base}/network.json";
          ssh     = fromJsonFile "${base}/ssh.json";
        };

      hostNames = builtins.filter
        (name: (builtins.readDir ./hosts).${name} == "directory")
        (builtins.attrNames (builtins.readDir ./hosts));

      hostInit = host: import (./hosts + "/${host}/init.nix");

      # Build a NixOS configuration for a single host.
      mkHost = host:
        let
          init          = (hostInit host) // { hostname = host; };
          privateData   = mkPrivateData host;
          system        = init.system;
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
            inputs.flatpaks.nixosModules.default
            {
              networking.hostName = host;
              services.snap.enable = true;
              nixpkgs.config.allowUnfree = true;
              nixpkgs.overlays = overlays;
              home-manager.useGlobalPkgs = false;
              home-manager.useUserPackages = true; 
              home-manager.sharedModules = [
                inputs.sops-nix.homeManagerModules.sops
              ];
              home-manager.extraSpecialArgs = { inherit inputs pkgs-unstable init privateData; };
            }
          ];
          specialArgs = {
            inherit inputs pkgs-unstable init privateData;
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
