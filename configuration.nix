# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, pkgs-unstable, lib, systemSettings, userSettings, ... }:

let 
  locale = systemSettings.locale;
  username = userSettings.username;
  fullname = userSettings.fullname;
in {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/system/defaults.nix
    ];
    
  # Enable networking
  networking.hostName = systemSettings.hostname;
  networking.networkmanager.enable = true;
  networking.networkmanager.unmanaged = [ "enp6s0" ];
  systemd.network.enable = true; # For reference: /modules/system/sops.nix
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  
  # Set your time zone.
  time.timeZone = systemSettings.timezone;
   
  # Select internationalisation properties.
  i18n.defaultLocale = locale;
   
  i18n.extraLocaleSettings = {
    LC_ADDRESS = locale;
    LC_IDENTIFICATION = locale;
    LC_MEASUREMENT = locale;
    LC_MONETARY = locale;
    LC_NAME = locale;
    LC_NUMERIC = locale;
    LC_PAPER = locale;
    LC_TELEPHONE = locale;
    LC_TIME = locale;
  };
  
  # Enable the KDE Desktop environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "amdgpu" ];
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = systemSettings.keyLayout;
    variant = systemSettings.keyMap;
  };

  # Configure console keymap
  console.keyMap = systemSettings.keyMap;

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  sops.secrets."user/${username}/password".neededForUsers = true;
  
  users.users.${username} = {
    isNormalUser = true;
    description = fullname;
    hashedPasswordFile = config.sops.secrets."user/${username}/password".path;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      #  For user packages look at: ~/.dotfiles/nixos/modules/user/apps.ix. The alias is "apps".  
    ];
  };
   
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [ 
    # For systemwide packages look at: ~/.dotfiles/nixos/modules/system/apps.nix. The alias is "sapps".
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ];
  # networking.firewall.allowedUDPPorts = [ ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perf${userSettings.username}ectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
  
  nix.settings.extra-experimental-features = [ "nix-command" "flakes" ];
}
