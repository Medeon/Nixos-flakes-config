{ pkgs, config, lib, ... }:
let
  pam     = config.security.pam.package;
  pam_u2f = pkgs.pam_u2f;
  kwallet = pkgs.kdePackages.kwallet-pam;

  u2fArgs = "authfile=/etc/nixos/Yubico/u2f_keys cue";

  sharedSessionStack = ''
    session required  ${pam}/lib/security/pam_env.so conffile=/etc/pam/environment readenv=0
    session required  ${pam}/lib/security/pam_unix.so
    session optional  ${pkgs.systemd}/lib/security/pam_systemd.so
    session required  ${pam}/lib/security/pam_limits.so
    session optional  ${kwallet}/lib/security/pam_kwallet5.so
  '';

  # Auth stack for services that need: password → yubikey (true MFA).
  #
  # Written explicitly because NixOS's generated stack uses `unix sufficient`
  # which short-circuits on correct password, bypassing u2f. The
  # unix-early/try_first_pass workaround NixOS uses for kwallet conflicts
  # with changing unix's control flag.
  #
  # Stack logic:
  #   unix-early  optional                   – prompts once, stores PAM_AUTHTOK for kwallet
  #   kwallet     optional                   – unlocks wallet using PAM_AUTHTOK
  #   unix        [success=ok default=die]   – validates password, continue or die
  #   u2f         required                   – yubikey touch must succeed
  mfaAuthStack = ''
    auth  optional                   ${pam}/lib/security/pam_unix.so likeauth nullok
    auth  optional                   ${kwallet}/lib/security/pam_kwallet5.so
    auth  [success=ok default=die]   ${pam}/lib/security/pam_unix.so nullok try_first_pass
    auth  required                   ${pam_u2f}/lib/security/pam_u2f.so ${u2fArgs}
  '';

  # PAM text for sddm (normal login with MFA).
  sddmText = lib.mkForce ''
    # Account management.
    account required  ${pam}/lib/security/pam_unix.so

    # Authentication management.
    ${mfaAuthStack}

    # Password management.
    password sufficient ${pam}/lib/security/pam_unix.so nullok yescrypt

    # Session management.
    ${sharedSessionStack}
  '';

  # PAM text for sddm-autologin (no credentials required).
  sddmAutologinText = lib.mkForce ''
    # Account management.
    account required  ${pam}/lib/security/pam_unix.so

    # Authentication management.
    auth  required  ${pam}/lib/security/pam_permit.so

    # Password management.
    password sufficient ${pam}/lib/security/pam_unix.so nullok yescrypt

    # Session management.
    ${sharedSessionStack}
  '';
in
{
  security.pam = {
    u2f = {
      enable = true;
      control = "required";
      settings = {
        authfile = "/etc/nixos/Yubico/u2f_keys";
        cue = true;
      };
    };
    services = {
      # ----------------------------------------------------------------
      # login (TTY): password → yubikey
      # ----------------------------------------------------------------
      login = {
        unixAuth      = true;
        u2fAuth       = true;
        enableKwallet = true;
        text = lib.mkForce ''
          # Account management.
          account required  ${pam}/lib/security/pam_unix.so

          # Authentication management.
          ${mfaAuthStack}

          # Password management.
          password sufficient ${pam}/lib/security/pam_unix.so nullok yescrypt

          # Session management.
          session required  ${pam}/lib/security/pam_loginuid.so
          session optional  ${pkgs.util-linux}/lib/security/pam_lastlog2.so silent
          ${sharedSessionStack}
        '';
      };

      # ----------------------------------------------------------------
      # sudo: yubikey touch only (no password)
      # ----------------------------------------------------------------
      sudo = {
        unixAuth = false;
        u2fAuth  = true;
        text = lib.mkForce ''
          # Account management.
          account required  ${pam}/lib/security/pam_unix.so

          # Authentication management.
          auth  sufficient  ${pam_u2f}/lib/security/pam_u2f.so ${u2fArgs}
          auth  required    ${pam}/lib/security/pam_deny.so
        '';
      };

      # ----------------------------------------------------------------
      # sddm: password → yubikey MFA
      # ----------------------------------------------------------------
      sddm = {
        unixAuth        = true;
        kwallet.enable  = true;
        kwallet.package = kwallet;
        text            = sddmText;
      };

      # ----------------------------------------------------------------
      # sddm-autologin: no credentials (permit)
      # ----------------------------------------------------------------
      sddm-autologin = {
        kwallet.enable  = true;
        kwallet.package = kwallet;
        text            = sddmAutologinText;
      };
    };
  };
}
