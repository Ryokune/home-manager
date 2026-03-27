{
  self,
  lib,
  pkgs,
  config,
  ...
}:
{
  programs.swaylock = {
    enable = true;
    settings = {
      indicator-idle-visible = true; # Show key indicator

      # Other settings
      font = "Maple Mono NF CN";
      font-size = 24;
      indicator-radius = 100;
      indicator-thickness = 7;
    };
  };
}
