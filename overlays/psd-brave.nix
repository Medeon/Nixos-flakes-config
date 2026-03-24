
final: prev: {
  profile-sync-daemon = prev.profile-sync-daemon.overrideAttrs (old: {
    # 1. Add the Brave browser definition file to the package
    postInstall = (old.postInstall or "") + ''
      mkdir -p $out/share/psd/browsers
      cat > $out/share/psd/browsers/brave <<'EOF'
DIRArr[0]="$XDG_CONFIG_HOME/BraveSoftware/Brave-Browser"
PSNAME="brave"
EOF
    '';
    # 2. Update the script to point to this new package's share directory
    # instead of the original one, so it can find the new brave file.
    postFixup = (old.postFixup or "") + ''
      sed -i "s|SHAREDIR=.*|SHAREDIR=\"$out/share/psd\"|" $out/bin/profile-sync-daemon
    '';
  });
}