{
  self,
  config,
  ...
}:
{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        launch-prefix = "app2unit --";
      };
    };
  };
}
