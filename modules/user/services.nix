{ pkgs, ... }:
{
  services.psd = {
    enable = true;
    resyncTimer = "1h";
  };
}
