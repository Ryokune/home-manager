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
            After = [ "awww.service" ];
            BindsTo = [ "awww.service" ];
          };
          Service = {
            ExecStart = "${pkgs.awww}/bin/awww img ${config.stylix.image} --transition-type fade";
            Type = "oneshot";
            Restart = "on-failure";
          };
          Install.WantedBy = [ "awww.service" ];
        };
      };
    };
}
