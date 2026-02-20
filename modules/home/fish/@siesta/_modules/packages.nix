{ pkgs, ... }:
{

  home.packages = with pkgs; [
    substratum.wake-home
    app2unit
    seahorse
    ripgrep
    trash-cli
    swww
    wl-clipboard
    vesktop
  ];

}
