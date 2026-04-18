{ pkgs, ... }:
{
  services.printing.enable = true;
  services.udev.packages = with pkgs; [ yubikey-personalization libu2f-host ];
  services.pcscd.enable = true;
  services.openssh.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  
  #services.flatpak.enable = true;
}
