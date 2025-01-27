{ pkgs, ... }: {
  home.file.".config/niri/config.kdl".source = ../plain/niri.kdl;
  home.file.".config/i3bar-river/config.toml".source = ../plain/i3bar-river.toml;

  programs.i3status-rust.enable = true;
}
