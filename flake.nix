{

  description = "flake";

  inputs = {
  
    # nixos nixpkgs github repository 
    nixpkgs.url = "nixpkgs/nixos-25.11";
    home-manager = {
      # home-manager github repository
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, home-manager, ... }: 
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
        username = "ejan";
        fullname = "Evert-Jan";
        email = "evertjanvandijk@mailbox.org";
        dir = "~/.dotfiles/nixos";
        editor = "vim";
      };    
    in {
      nixosConfigurations.nixos = systemSettings.lib.nixosSystem {
        system = systemSettings.system;
        modules = [ ./configuration.nix ];
        specialArgs = {
          inherit systemSettings;
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
