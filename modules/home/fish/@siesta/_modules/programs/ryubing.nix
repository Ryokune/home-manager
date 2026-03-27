{
  pkgs,
  self,
  ...
}:
{
  home.packages = with pkgs; [
    substratum.ryubing-canary
  ];
}
