{ self, lib, ... }:

{
  flake.homeModules.swww =
    {
      pkgs,
      config,
      lib,
      ...
    }:

    {
      imports = [
        self.homeModules.swww-stylix
      ];

      services.swww.enable = true;
      services.swwwStylix.enable = config.stylix.image != null;

    };
}
