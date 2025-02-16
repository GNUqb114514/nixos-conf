{ pkgs, ... }: {
  home.file.".config/niri/config.kdl".source = ../plain/niri.kdl;
  home.file.".config/i3bar-river/config.toml".source = ../plain/i3bar-river.toml;

  programs.i3status-rust.enable = true;
  programs.i3status-rust.bars = {
    default = {
      blocks = [
        {
          block = "custom";
          command = "nix shell nixpkgs#python313 --command python3 ${../script/get-fcitx-im-label.py}";
          interval = "once";
          signal = 4;
        }
        {
          alert = 10.0;
          block = "disk_space";
          info_type = "available";
          interval = 60;
          path = "/";
          warning = 20.0;
        }
        {
          block = "memory";
          format = " $icon $mem_used_percents ";
          format_alt = " $icon swap $swap_used_percents ";
        }
        {
          block = "cpu";
          interval = 1;
        }
        {
          block = "load";
          format = " $icon $1m ";
          interval = 1;
        }
        {
          block = "sound";
        }
        {
          block = "time";
          format = " $timestamp.datetime(f:'%a %d/%m %R') ";
          interval = 60;
        }
      ];
      icons = "material-nf";
      theme = "native";
    };
  };

  home.file.".local/share/fcitx5/lua/imeapi/extensions/emit-signal-to-bar.lua".source = ../script/emit-signal-to-bar.lua;
}
