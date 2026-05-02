{ pkgs, config, inputs, userData, ... }:
let
  username = userData.username;
  secretspath = builtins.toString inputs.mysecrets;
in {
  sops = {
    age.keyFile = "/home/${username}/.config/sops/age/keys.txt";

    defaultSopsFile = "${secretspath}/secrets.yaml";
    validateSopsFiles = false;
        
    secrets."user/${username}/password" = {};
    secrets."user/${username}/email" = {};
    secrets."user/${username}/fullname" = {};
    secrets."ssh/ubuntu/ip-address" = {};
    secrets."ssh/ubuntu/port" = {};
    secrets."ssh/windows/ip-address" = {};
    secrets."ssh/windows/user" = {};
    secrets = {
      "keys/ssh/${username}/id_nixos/private_key" = {
        path = "/home/${username}/.ssh/id_nixos";
      };
    };
  };
}