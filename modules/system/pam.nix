{ pkgs, config, lib, ... }:
let
  pam     = config.security.pam.package;
  pam_u2f = pkgs.pam_u2f;
  kwallet = pkgs.kdePackages.kwallet-pam;
  u2fArgs = "authfile=/etc/nixos/Yubico/u2f_keys cue";

  # Auth stack for services that need: password → yubikey (true MFA).
  #
  # Written explicitly because NixOS's generated stack uses `unix sufficient`
  # which short-circuits on correct password, bypassing u2f. Changing unix's
  # control flag is incompatible with NixOS's kwallet integration options, so
  # the full stack is managed here.
  #
  # Stack logic:
  #   unix        optional   likeauth nullok                – prompts once, stores PAM_AUTHTOK for kwallet
  #   kwallet     optional                                  – unlocks wallet using PAM_AUTHTOK
  #   unix        [success=ok default=die]  try_first_pass  – validates password, continue or die
  #   u2f         required                                  – yubikey touch must succeed
  mfaAuthStack = ''
    auth  optional                   ${pam}/lib/security/pam_unix.so likeauth nullok
    auth  optional                   ${kwallet}/lib/security/pam_kwallet5.so
    auth  [success=ok default=die]   ${pam}/lib/security/pam_unix.so nullok try_first_pass
    auth  required                   ${pam_u2f}/lib/security/pam_u2f.so ${u2fArgs}
  '';

  sharedSessionStack = ''
    session required  ${pam}/lib/security/pam_env.so conffile=/etc/pam/environment readenv=0
    session required  ${pam}/lib/security/pam_unix.so
    session optional  ${pkgs.systemd}/lib/security/pam_systemd.so
    session required  ${pam}/lib/security/pam_limits.so
    session optional  ${kwallet}/lib/security/pam_kwallet5.so
  '';

  sharedAccountRule = ''
    account required  ${pam}/lib/security/pam_unix.so
  '';

  sharedPasswordRule = ''
    password sufficient ${pam}/lib/security/pam_unix.so nullok yescrypt
  '';
  
  sddmText = lib.mkForce ''
    # Account management.
    ${sharedAccountRule}

    # Authentication management.
    ${mfaAuthStack}

    # Password management.
    ${sharedPasswordRule}

    # Session management.
    ${sharedSessionStack}
  '';

  loginText = lib.mkForce ''
    # Account management.
    ${sharedAccountRule}

    # Authentication management.
    ${mfaAuthStack}

    # Password management.
    ${sharedPasswordRule}

    # Session management.
    session required  ${pam}/lib/security/pam_loginuid.so
    session optional  ${pkgs.util-linux}/lib/security/pam_lastlog2.so silent
    ${sharedSessionStack}
  '';
  
  sudoText = lib.mkForce ''
    # Account management.
    ${sharedAccountRule}

    # Authentication management.
    auth  sufficient  ${pam_u2f}/lib/security/pam_u2f.so ${u2fArgs}
    auth  required    ${pam}/lib/security/pam_deny.so
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
      
      login = {
        unixAuth      = true;
        u2fAuth       = true;
        enableKwallet = true;
        text = loginText;
      };

      sudo = {
        unixAuth = false;
        u2fAuth  = true;
        text = sudoText;
      };

      sddm = {
        unixAuth        = true;
        kwallet.enable  = true;
        kwallet.package = kwallet;
        text            = sddmText;
      };
    };
  };
}
