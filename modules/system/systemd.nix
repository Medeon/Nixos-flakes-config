{ pkgs, ... }:
{

  # systemd.packages = with pkgs-unstable; [ lact ];
  # systemd.services.lactd.wantedBy = ["multi-user.target"];
  #systemd.packages = with pkgs; [ profile-sync-daemon ];
  #systemd.user.services.profile-sync-daemon.wantedBy = [ "multi-user.target" ];
  # services.lact.enable = true;

  systemd.tmpfiles.rules = [
    "L /var/lib/snapd/hostfs/etc/passwd - - - - /etc/passwd" # Bind mounts to snapd hostfs
    "L /var/lib/snapd/hostfs/etc/group - - - - /etc/group"   # for access to etc.. passwd & group 
    "L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"
  ];
}
