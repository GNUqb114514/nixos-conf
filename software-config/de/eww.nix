{ pkgs, config, ... }: {
  programs.eww = {
    enable = true;
    configDir = config.lib.file.mkOutOfStoreSymlink "/home/qb114514/nixos-conf/software-config/de/eww/";
  };

  home.file.".local/share/fcitx5/lua/imeapi/extensions/emit-signal-to-bar.lua".source = ./emit-signal-to-bar.lua;
}
