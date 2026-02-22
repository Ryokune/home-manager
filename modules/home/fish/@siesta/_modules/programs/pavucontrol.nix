{
  pkgs,
  self,
  ...
}:
{
  home.packages = with pkgs; [
    pavucontrol
  ];
}
