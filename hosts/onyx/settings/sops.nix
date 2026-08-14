{ pkgs, inputs, config, init, ... }:
let
  user = init.sysAdmin;
  secretspath = builtins.toString inputs.mysecrets;
in {
  imports =
    [
      inputs.sops-nix.nixosModules.sops
    ];

  sops = {
    defaultSopsFile = "${secretspath}/secrets.yaml";
    defaultSopsFormat = "yaml";
    
    age = {
      keyFile = "/home/${user}/.config/sops/age/keys.txt";
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      generateKey = true;
    };

    secrets."keys/ssh/btrbk/id_btrbk_key/private_key" = {
      owner = "btrbk";
    };
    secrets."user/${user}/password" = {};
  };
}