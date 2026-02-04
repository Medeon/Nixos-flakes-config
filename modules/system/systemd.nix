{ config, pkgs, lib, ... }:
{
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
 
    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    # Enable networking
    networking.networkmanager.enable = true;

    # Enable CUPS to print documents.
    services.printing.enable = true;
 
    # Udev rules for yubikey
    services.udev.packages = with pkgs; [ yubikey-personalization libu2f-host ];
 
    # Enable pcscd for smartcard support
    services.pcscd.enable = true;
    
    # Enable the OpenSSH daemon.
    services.openssh.enable = true;
}
