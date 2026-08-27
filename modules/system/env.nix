{ config, init, pkgs, ... }:
{
  environment.variables = {
    XKB_DEFAULT_LAYOUT = init.keyLayout;
    XKB_DEFAULT_VARIANT = init.keyMap;
  };
}