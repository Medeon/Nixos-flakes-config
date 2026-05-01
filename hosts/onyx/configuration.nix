# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, pkgs-unstable, lib, userSettings, ... }:

let
  username = userSettings.username;
  fullname = userSettings.fullname;
in {
  imports = [
    ../../modules/system/defaults.nix
    ../../common/configuration.nix
  ];
  
  # config = {
  #   systemSettings = {
  #     #TO DO
  #   };
  # };  
  
  # Enable the KDE Desktop environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  #services.displayManager.sddm.autoLogin.enable = true;
  #services.displayManager.sddm.autoLogin.user = "ejan";

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  hardware.bluetooth.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  sops.secrets."user/${username}/password".neededForUsers = true;
  
  users.users.${username} = {
    isNormalUser = true;
    description = fullname;
    hashedPasswordFile = config.sops.secrets."user/${username}/password".path;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      #  For user packages look at: ~/.dotfiles/nixos/modules/user/apps.nix. The alias is "apps".  
    ];
  };
   
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ 
    # For systemwide packages look at: ~/.dotfiles/nixos/modules/system/apps.nix. The alias is "sapps".
  ];

}
