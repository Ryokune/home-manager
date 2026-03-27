{ pkgs, ... }:
{
  stylix.cursor = {
    package = pkgs.volantes-cursors;
    name = "volantes_cursors";
    size = 24;
  };
  stylix.targets.gtksourceview.enable = false;
}
