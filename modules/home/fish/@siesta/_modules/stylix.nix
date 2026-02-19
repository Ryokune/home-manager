{
  self,
  pkgs,
  config,
  inputs,
  ...
}:
{
  imports = [
  ];
  stylix = {
    enable = true;
    autoEnable = true;
    image = ../ado.jpeg;
    polarity = "dark";
    opacity.terminal = 0.8;
    icons = {
      enable = true;
      package = pkgs.papirus-icon-theme;

      # You can specify the dark/light variants
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };
    fonts = {
      monospace = {
        package = pkgs.maple-mono.CN;
        name = "Maple Mono CN";
      };
      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 11;
        terminal = 11.5;
        desktop = 12;
        popups = 12;
      };

    };

    # TODO: Move this into its own folder? eg: stylix/mako.nix, stylix/firefox.nix
    # OR: Place these stylix options INSIDE of the packages themselves? eg: programs/mako.nix, etc.
    targets = {
      nvf.enable = false;
      mako = {
        fonts.override = {
          serif = config.stylix.fonts.monospace;
          sansSerif = config.stylix.fonts.monospace;
          emoji = config.stylix.fonts.monospace;
        };
      };
      firefox = {
        colors.enable = true;
        colorTheme.enable = true;
        profileNames = [ "default" ];
      };
      alacritty = {
        colors.enable = false;
      };
      fuzzel = {
        fonts.override = {
          serif = config.stylix.fonts.monospace;
          sansSerif = config.stylix.fonts.monospace;
          emoji = config.stylix.fonts.monospace;
        };
      };
    };
  };
}
