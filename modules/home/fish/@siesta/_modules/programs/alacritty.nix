{
  self,
  config,
  ...
}:
{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        blur = true;
      };
    };
  };
  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [ "alacritty.desktop" ];
    };
  };
  home.sessionVariables = {
    TERMINAL = "alacritty";
  };
}
