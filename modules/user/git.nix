{ pkgs, config, userSettings, ... }:
let
  username = userSettings.username;
in {
  sops.templates."git-identity" = {
    path = "/home/${username}/.config/git/identity";
    content = ''
      [user]
        name = ${config.sops.placeholder."user/${username}/fullname"}
        email = ${config.sops.placeholder."user/${username}/email"}
    '';
  };
  
  programs.git = {
    enable = true;
    includes = [
      { path = "~/.config/git/identity"; } 
    ];
    settings = {
      init.defaultBranch = "main";
    };
  };
}
