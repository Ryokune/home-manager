{ self, ... }:

{
  flake.homeModules.swww =
    {
      config,
      ...
    }:

    {
      imports = [
        self.homeModules.swww-stylix
      ];

      services.awww.enable = true;
      services.swwwStylix.enable = config.stylix.image != null;

    };
}
