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
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nix-snapd, ... }: 
    let
      # ----- SYSTEM SETTING ----- #
      systemSettings = {
        system = "x86_64-linux";
        hostname = "nixos";
        timezone = "Europe/Amsterdam";
        locale = "nl_NL.UTF-8";
        keyLayout = "nl";
        keyMap = "us";
      };    
      # ----- USER SETTINGS ----- #
      userSettings = {
        username = "ejan";
        fullname = "Evert-Jan";
        email = "evertjanvandijk@mailbox.org";
        dir = "~/.dotfiles/nixos";
        editor = "vim";
      };
      lib = nixpkgs.lib;
      pkgs = import nixpkgs {
        system = systemSettings.system;
        config.allowUnfree = true;
      };
      pkgs-unstable = import nixpkgs-unstable {
        system = systemSettings.system;
        config.allowUnfree = true;
      };
    in {
      nixosConfigurations.nixos = lib.nixosSystem {
        inherit pkgs;
        modules = [ 
          ./configuration.nix 
          nix-snapd.nixosModules.default
          { services.snap.enable = true; }
        ];
        specialArgs = {
          inherit systemSettings;
          inherit userSettings;
          inherit pkgs-unstable;
        };
      };
      homeConfigurations.${userSettings.username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ 
          ./home.nix
        ];
        extraSpecialArgs = {
          inherit userSettings;
          inherit pkgs-unstable;
        };
      };
    };
}
