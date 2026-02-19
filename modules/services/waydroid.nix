{ ... }:
{
  flake.homeModules.waydroid-service =
    { pkgs, ... }:
    {
      systemd.user.services.waydroid-session = {
        Unit = {
          Description = "Waydroid User Session";
          After = [ "waydroid-container.service" ];
        };
        Install = {
          WantedBy = [ "default.target" ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.waydroid-nftables}/bin/waydroid session start";
          ExecStop = "${pkgs.waydroid-nftables}/bin/waydroid session stop";

          # Clean up processes on exit
          KillMode = "mixed";

          # Resource limits: 4GB Max, 3GB cache threshold
          MemoryMax = "4G";
          MemoryHigh = "3G";

          TimeoutStopSec = "15s";
          Restart = "on-failure";
        };
      };
    };
}
