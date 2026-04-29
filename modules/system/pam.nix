{ pkgs, ... }:
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
                unixAuth = true;
                u2fAuth = true;
                enableKwallet = true;
            };
            sudo = {
                #control = "sufficient";
                u2fAuth = true;
            };
            sddm = { 
                unixAuth = true;
                u2fAuth = true;
                enableKwallet = true;
                kwallet = {
                    enable = true;
                    package = pkgs.kdePackages.kwallet-pam;
                };
            };    
            sddm-autologin = {
                unixAuth = true;
                u2fAuth = true;
                kwallet = {
                    enable = true;
                    package = pkgs.kdePackages.kwallet-pam;
                };
            };
        };
    };
}