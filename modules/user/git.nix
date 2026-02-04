{ config, pkgs, ... }:
{
    programs.git = {
        enable = true;
        settings = {    
            user = {
                name = "Evert-Jan van Dijk";
                email = "evertjanvandijk@mailbox.org";
            };
            init.defaultBranch = "main";
        };
    };
}
