{ config, ... }:
{
  home.sessionVariables = {

    NH_HOME_FLAKE = "${config.home.homeDirectory}/.config/home-manager";

    # remove if not using uwsm
    APP2UNIT_SLICES = "a=app-graphical.slice b=background-graphical.slice s=session-graphical.slice";
  };
}
