{ pkgs, ... }: {
  programs.eww = {
    enable = true;
    configdir = ./eww;
  };
}
