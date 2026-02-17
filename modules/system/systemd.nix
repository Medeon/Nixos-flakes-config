{ config, pkgs, pkgs-unstable, lib, ... }:
{
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # Enable networking
  networking.networkmanager.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.udev.packages = with pkgs; [ yubikey-personalization libu2f-host ];
  # Enable pcscd for smartcard support
  services.pcscd.enable = true;
  services.openssh.enable = true;
  
  # systemd.packages = with pkgs-unstable; [ lact ];
  # systemd.services.lactd.wantedBy = ["multi-user.target"];

  # services.lact.enable = true;

  systemd.tmpfiles.rules = [
    "L /var/lib/snapd/hostfs/etc/passwd - - - - /etc/passwd" # Bind mounts to snapd hostfs
    "L /var/lib/snapd/hostfs/etc/group - - - - /etc/group"   # for access to etc.. passwd & group 
    "L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"
  ];
}
