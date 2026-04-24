final: prev: {
  profile-sync-daemon = prev.profile-sync-daemon.overrideAttrs (old: {
    postFixup = (old.postFixup or "") + ''
      cp ${final.writeText "psd-brave" ''
        DIRArr[0]="$XDG_CONFIG_HOME/BraveSoftware/Brave-Browser"
        PSNAME="brave"
      ''} $out/share/psd/browsers/brave
    '';
  });
}
