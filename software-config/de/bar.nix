{ pkgs, ... }: {
  home.packages = with pkgs; [
    i3bar-river
  ];

  # i3bar configuration is not provided by home manager.
  home.file.".config/i3bar-river/config.toml".source = ./i3bar-river.toml;

  programs.i3status-rust.enable = true;
  programs.i3status-rust.bars = {
    default = {
      blocks = [
        {
          block = "custom";
          command = "cat /sys/class/leds/input16::capslock/brightness | jq 'if .==1 then \"󰪛 \" else halt end' -r";
          interval = 0.5;
          hide_when_empty = true;
        }
        {
          block = "custom";
          command = "nix shell nixpkgs#python313 --command python3 ${./get-fcitx-im-label.py}";
          interval = "once";
          signal = 4;
        }
        {
          block = "custom";
          command = "sleep 1 && niri msg -j focused-window | jq 'if .==null then halt elif .app_id==\"Alacritty\" and (.title | test(\"^\\\\d+ --client-id \\\\d+ - \\\\(term://.+//\\\\d+:yazi .+ --chooser-file .+\\\\) - Nvim$\")) then \"Yazi on NVIM\" elif .app_id==\"firefox\" then \"Firefox\" else .title end' -r";
          interval = 3;
          hide_when_empty = true;
        }
        {
          alert = 10.0;
          block = "disk_space";
          info_type = "available";
          interval = 60;
          path = "/nix";
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

  # Fcitx5 side for auto-updating
  home.file.".local/share/fcitx5/lua/imeapi/extensions/emit-signal-to-bar.lua".source = ./emit-signal-to-bar.lua;
}
