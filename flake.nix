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
    
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # --------------- PRIVATE REPOSITORY --------------- #
    mysecrets = {
      url = "git+ssh://git@gitlab.com/ejandev/nix-secrets.git?ref=main&shallow=1";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nix-snapd, sops-nix, nix-index-database, ... }@inputs: 
    let
      # --------------- SYSTEM SETTING --------------- #
      systemSettings = {
        system = "x86_64-linux";
        hostname = "nixos";
        timezone = "Europe/Amsterdam";
        locale = "nl_NL.UTF-8";
        keyLayout = "nl";
        keyMap = "us";
      };    
      # ----- USER SETTINGS ----- #
      userSettings = rec {
        username = "ejan";
        fullname = "Evert-Jan";
        flakeDir = "/home/${username}/.dotfiles/nixos";
        editor = "vim";
      };
      lib = nixpkgs.lib;
      overlays = [
        (import ./overlays/psd-brave.nix)
      ];
      pkgs = import nixpkgs {
        system = systemSettings.system;
        config.allowUnfree = true;
        inherit overlays; 
      };
      pkgs-unstable = import nixpkgs-unstable {
        system = systemSettings.system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations.nixos = lib.nixosSystem {
        modules = [ 
          ./configuration.nix 
          nix-snapd.nixosModules.default
          sops-nix.nixosModules.sops
          nix-index-database.nixosModules.default
          { 
            services.snap.enable = true; 
            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = overlays;
          }
        ];
        specialArgs = {
          inherit inputs;
          inherit systemSettings;
          inherit userSettings;
          inherit pkgs-unstable;
        };
      };
      homeConfigurations.${userSettings.username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ 
          ./home.nix
          sops-nix.homeManagerModules.sops
        ];
        extraSpecialArgs = {
          inherit inputs;
          inherit userSettings;
          inherit pkgs-unstable;
        };
      };
    };
}
