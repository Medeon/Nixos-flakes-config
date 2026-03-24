{ pkgs, ... }:
{  
    security.pam = {
        u2f = {    
            enable = true;
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
                #control = "sufficient";
                u2fAuth = true;
            };
            sddm = { 
                unixAuth = true;
                u2fAuth = true;
                enableKwallet = true;
            };    
            sddm-autologin = {
                unixAuth = true;
                u2fAuth = true;
            };
        };
    };
}
