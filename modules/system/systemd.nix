{ pkgs, ... }:
{
  systemd.tmpfiles.rules = [
    "L /var/lib/snapd/hostfs/etc/passwd - - - - /etc/passwd" # Bind mounts to snapd hostfs
    "L /var/lib/snapd/hostfs/etc/group - - - - /etc/group"   # for access to etc.. passwd & group 
    "L+ /opt/rocm/hip - - - - ${pkgs.rocmPackages.clr}"
  ];
}
