{
  self,
  config,
  ...
}:
{
  programs.git = {
    enable = true;
    signing = {
      key = "10928E38A063FB75";
      signByDefault = true;
    };
    settings = {
      user = {
        name = config.home.username;
        email = "kiokunee@gmail.com";
      };
      safe.directory = "/etc/nixos";
      init = {
        defaultBranch = "main";
      };
      submodule.recurse = true;
      push.recurseSubmodules = "check";
    };
  };
}
