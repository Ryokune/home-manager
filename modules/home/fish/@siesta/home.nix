{
  self,
  inputs,
  ...
}:
{
  perSystem =
    { pkgs, ... }:
    {
      legacyPackages.homeConfigurations."fish@siesta" = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          inputs.dotfiles.homeModules.default
          inputs.nvf.homeManagerModules.default
          self.homeModules.waydroid-service
          self.homeModules.swww
          inputs.stylix.homeModules.stylix
          (inputs.import-tree ./_modules)
          {
            nixpkgs.overlays = [ inputs.substratum.overlays.default ];
            stylix.image = ./ado.jpeg;
            home.username = "fish";
            home.homeDirectory = "/home/fish";
            home.stateVersion = "25.11";
          }
        ];
      };
    };
}
