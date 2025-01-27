{ pkgs, ... }: {
  home.file.".config/niri/config.kdl".source = ../plain/niri.kdl;
  home.file.".config/i3blocks/config".source = ../plain/i3blocks.ini;
  home.file.".config/i3bar-river/config.toml".source = ../plain/i3bar-river.toml;
}
