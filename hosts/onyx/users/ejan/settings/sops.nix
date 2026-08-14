{ pkgs, config, inputs, ... }:
let
  secretspath = builtins.toString inputs.mysecrets;
in {
  sops = {
    age.keyFile = "/home/ejan/.config/sops/age/keys.txt";

    defaultSopsFile = "${secretspath}/secrets.yaml";
    validateSopsFiles = false;
        
    secrets."user/ejan/password" = {};
    secrets = {
      "keys/ssh/ejan/id_nixos/private_key" = {
        path = "/home/ejan/.ssh/id_nixos";
      };
    };
  };
}