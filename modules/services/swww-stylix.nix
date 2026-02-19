{ self, ... }:
{
  flake.homeModules.swww-stylix =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    {
      options.services.swwwStylix = {
        enable = lib.mkEnableOption "swww stylix wallpaper service";
      };
      config = lib.mkIf config.services.swwwStylix.enable {
        systemd.user.services.swww-stylix-service = {
          Unit = {
            Description = "SWWW Stylix";
            After = [ "swww.service" ];
          };
          Service = {
            ExecStart = "${pkgs.swww}/bin/swww img ${config.stylix.image} --transition-type fade";
            Restart = "on-failure";
          };
          Install.WantedBy = [ "graphical-session.target" ];
        };
      };
    };
}
