{ pkgs, inputs, config, userData, ... }:
let
  username = userData.username;
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
      keyFile = "/home/${username}/.config/sops/age/keys.txt";
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      generateKey = true;
    };

    secrets."keys/ssh/btrbk/id_btrbk_key/private_key" = {
      owner = "btrbk";
    };
    secrets."ssh/ubuntu/ip-address" = {};
    secrets."ssh/ubuntu/port" = {};
    secrets."user/${username}/password" = {};
    secrets."user/${username}/fullname" = {};
    secrets."network/default-gateway" = {};
    secrets."network/ip-address" = {};
    secrets."network/dns1" = {};
    secrets."network/dns2" = {};
  };
}