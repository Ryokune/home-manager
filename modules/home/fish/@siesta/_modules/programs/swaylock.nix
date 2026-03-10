{
  self,
  pkgs,
  config,
  ...
}:
{
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      screenshots = true; # Use screenshot as background
      clock = true; # Show clock
      indicator = true; # Show key indicator

      # Blur effect: <radius>x<passes>
      effect-blur = "7x5";

      # Other settings
      font = "Maple Mono NF CN";
      font-size = 24;
      indicator-radius = 100;
      indicator-thickness = 7;
    };
  };
}
