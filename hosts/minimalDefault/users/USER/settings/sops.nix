{ pkgs, config, inputs, ... }:
let
  secretspath = builtins.toString inputs.mysecrets;
in {
  sops = {
    age.keyFile = "/home/USER/.config/sops/age/keys.txt";

    defaultSopsFile = "${secretspath}/secrets.yaml";
    validateSopsFiles = false;
        
    secrets."user/USER/password" = {};
  };
}