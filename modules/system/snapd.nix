{ config, pkgs, ... }:
{
  systemd.tmpfiles.rules = [
    "L /var/lib/snapd/hostfs/etc/passwd - - - - /etc/passwd"
    "L /var/lib/snapd/hostfs/etc/group - - - - /etc/group"
  ];
}  
