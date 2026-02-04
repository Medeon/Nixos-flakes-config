{ config, pkgs, lib, ... }:
{  
    security.pam = {
        u2f = {    
            control = "required";
            settings = {
                authfile = "/etc/nixos/Yubico/u2f_keys";
                cue = true;
		        #appid = "pam://$hostname";
                #origin = "pam://$hostname";
            };  
        };    
        services = {
            login = {
                unixAuth = true;
                u2fAuth = true;
                enableKwallet = true;
            };
            sudo = {
                u2fAuth = true;
                unixAuth = true;
            };
            sddm = { 
                unixAuth = true;
                u2fAuth = true;
                enableKwallet = true;
            };    
            sddm-autologin = {
                u2fAuth = true;
            };
        };
    };
}
