final: prev: {
  profile-sync-daemon = prev.profile-sync-daemon.overrideAttrs (old: {
    # We use postInstall instead of postFixup to ensure the file is writable
    # before the fixup phase (which might make it read-only).
    postInstall = (old.postInstall or "") + ''
      # 1. Create the Brave browser definition file
      mkdir -p $out/share/psd/browsers
      cat > $out/share/psd/browsers/brave <<'EOF'
DIRArr[0]="$XDG_CONFIG_HOME/BraveSoftware/Brave-Browser"
PSNAME="brave"
EOF

      # 2. Patch the script to point to the new package path.
      # The original script has a hardcoded SHAREDIR pointing to the original input package.
      # We replace it to point to $out (this new overridden package).
      sed -i "s|SHAREDIR=.*|SHAREDIR=\"$out/share/psd\"|" $out/bin/profile-sync-daemon
    '';
  });
}
