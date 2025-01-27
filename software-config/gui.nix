{ pkgs, ... }: {
  home.file.".config/niri/config.kdl".source = ../plain/niri.kdl;
}
