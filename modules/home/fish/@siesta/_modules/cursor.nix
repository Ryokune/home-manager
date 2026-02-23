{ pkgs, ... }:
{
  home.pointerCursor = {
    enable = true;
    package = pkgs.volantes-cursors;
    name = "volantes_cursors";
    gtk.enable = true;
    size = 24;
    x11.enable = true; # Ensures compatibility with XWayland apps
  };
}
