{ pkgs, ... }:
{

  home.packages = with pkgs; [
    substratum.hayase
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
