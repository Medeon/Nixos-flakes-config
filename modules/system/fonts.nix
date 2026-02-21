{ config, pkgs, pkgs-unstable, ... }:
{
  fonts.packages = with pkgs; [
    cifs-utils
    corefonts
    fira-code
    fira-code-symbols
    font-awesome_6
    google-fonts
    liberation_ttf
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    noto-fonts-color-emoji
    texlivePackages.merriweather
    texlivePackages.oswald
  ];
}
