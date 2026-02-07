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
    nix-snapd.inputs.nixpkgs.follows = "nixpkgs-unstable";
  };

  outputs = {self, nixpkgs, nixpkgs-unstable, home-manager, nix-snapd, ... }: 
    let
      # ----- SYSTEM SETTING ----- #
      systemSettings = {
        lib = nixpkgs.lib;
        system = "x86_64-linux";
        hostname = "nixos";
        timezone = "Europe/Amsterdam";
        locale = "nl_NL.UTF-8";
        keyLayout = "nl";
        keyMapping = "us";
      };    
      # ----- USER SETTINGS ----- #
      userSettings = {
        pkgs = nixpkgs.legacyPackages.${systemSettings.system};
        pkgs-unstable = nixpkgs-unstable.legacyPackages.${systemSettings.system};
        username = "ejan";
        fullname = "Evert-Jan";
        email = "evertjanvandijk@mailbox.org";
        dir = "~/.dotfiles/nixos";
        editor = "vim";
      };    
    in {
      nixosConfigurations.nixos = systemSettings.lib.nixosSystem {
        system = systemSettings.system;
        modules = [ 
          ./configuration.nix 
          nix-snapd.nixosModules.default
          ({ config, pkgs, ... }: {
            services.snap.enable = true;
          })
        ];
        specialArgs = {
          inherit systemSettings;
          inherit userSettings;
        };
      };
      homeConfigurations.${userSettings.username} = home-manager.lib.homeManagerConfiguration {
        pkgs =  userSettings.pkgs;
        modules = [ 
          ./home.nix
        ];
        extraSpecialArgs = {
          inherit userSettings;
        };
      };
    };
}
