{ lib, ... }:
{
  options.userSettings = {
    username = lib.mkOption {
      type = lib.types.str;
      description = "The home-manager user's login name.";
    };

    fullname = lib.mkOption {
      type = lib.types.str;
      description = "The user's full name or display name.";
    };

    email = lib.mkOption {
      type = lib.types.str;
      description = "The user's email address.";
    };

    git.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable Git for this user.";
    };

    psd.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable Profile Sync Daemon for this user.";
    };

    gpg.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable GPG for this user.";
    };

    gpg.pinentryProgram = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = null;
      description = "The pinentry package to use for GPG passphrase prompts. Required when gpg.enable = true.";
    };

    vim.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable Vim and related packages for this user.";
    };
  };
}
