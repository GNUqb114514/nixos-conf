{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.user.gui;
in {
  options.user.gui = with lib; {
    enable = mkEnableOption "GUI";

    swaync = mkEnableOption "swaync";
    mpv = mkEnableOption "mpv";

    swayosd = mkEnableOption "swayosd";
  };

  config = lib.mkIf cfg.enable {
    programs.niri.enable = true;
    programs.niri.package = pkgs.niri;

    programs.niri.settings = {
      layout = {
        preset-column-widths = let
          proportion = value: {proportion = value;};
          fixed = value: {fixed = value;};
        in [
          (proportion (1. / 3.))
          (proportion (1. / 2.))
          (proportion (2. / 3.))
        ];

        gaps = 8;
      };
      window-rules = [
        # Open the Firefox picture-in-picture player as floating by default.
        {
          matches = [
            {
              app-id = "firefox$";
              title = "^画中画$";
            }
          ];
          open-floating = true;
          default-window-height = let
            proportion = value: {proportion = value;};
          in
            proportion 0.4;
          default-column-width = let
            proportion = value: {proportion = value;};
          in
            proportion 0.4;
          open-focused = false;
        }
      ];
      spawn-at-startup =
        [
          {command = ["eww" "open" "topbar"];}
        ]
        ++ lib.optionals config.user.fcitx.enable [
          {command = ["systemctl" "--user" "start" "fcitx5-daemon.service"];}
        ];
      binds = with config.lib.niri.actions;
        lib.mkMerge [
          {
            "Mod+Shift+Slash".action = show-hotkey-overlay;

            "Mod+D".action = spawn "fuzzel";
            "Mod+Alt+L".action = spawn "swaylock";

            "XF86AudioRaiseVolume" = {
              action = spawn "swayosd-client" "--output-volume=raise";
              allow-when-locked = true;
            };
            "XF86AudioLowerVolume" = {
              action = spawn "swayosd-client" "--output-volume=lower";
              allow-when-locked = true;
            };
            "XF86AudioMute" = {
              action = spawn "swayosd-client" "--output-volume=mute-toggle";
              allow-when-locked = true;
            };
            "XF86AudioMicMute" = {
              action = spawn "swayosd-client" "--input-volume=mute-toggle";
              allow-when-locked = true;
            };

            "Mod+Q".action = close-window;

            "Mod+Left".action = focus-column-left;
            "Mod+Right".action = focus-column-right;
            "Mod+Up".action = focus-window-up;
            "Mod+Down".action = focus-window-down;
            "Mod+H".action = focus-column-left;
            "Mod+J".action = focus-window-down;
            "Mod+K".action = focus-window-up;
            "Mod+L".action = focus-column-right;

            "Mod+Ctrl+Left".action = move-column-left;
            "Mod+Ctrl+Right".action = move-column-right;
            "Mod+Ctrl+Up".action = move-window-up;
            "Mod+Ctrl+Down".action = move-window-down;
            "Mod+Ctrl+H".action = move-column-left;
            "Mod+Ctrl+J".action = move-window-down;
            "Mod+Ctrl+K".action = move-window-up;
            "Mod+Ctrl+L".action = move-column-right;

            "Mod+Shift+Left".action = focus-monitor-left;
            "Mod+Shift+Right".action = focus-monitor-right;
            "Mod+Shift+Up".action = focus-monitor-up;
            "Mod+Shift+Down".action = focus-monitor-down;
            "Mod+Shift+H".action = focus-monitor-left;
            "Mod+Shift+J".action = focus-monitor-down;
            "Mod+Shift+K".action = focus-monitor-up;
            "Mod+Shift+L".action = focus-monitor-right;

            "Mod+Shift+Ctrl+Left".action = move-column-to-monitor-left;
            "Mod+Shift+Ctrl+Right".action = move-column-to-monitor-right;
            "Mod+Shift+Ctrl+Up".action = move-column-to-monitor-up;
            "Mod+Shift+Ctrl+Down".action = move-column-to-monitor-down;
            "Mod+Shift+Ctrl+H".action = move-column-to-monitor-left;
            "Mod+Shift+Ctrl+J".action = move-column-to-monitor-down;
            "Mod+Shift+Ctrl+K".action = move-column-to-monitor-up;
            "Mod+Shift+Ctrl+L".action = move-column-to-monitor-right;

            "Mod+Page_Down".action = focus-workspace-down;
            "Mod+Page_Up".action = focus-workspace-up;
            "Mod+U".action = focus-workspace-down;
            "Mod+I".action = focus-workspace-up;

            "Mod+Ctrl+Page_Down".action = move-column-to-workspace-down;
            "Mod+Ctrl+Page_Up".action = move-column-to-workspace-up;
            "Mod+Ctrl+U".action = move-column-to-workspace-down;
            "Mod+Ctrl+I".action = move-column-to-workspace-up;

            "Mod+Shift+Page_Down".action = move-workspace-down;
            "Mod+Shift+Page_Up".action = move-workspace-up;
            "Mod+Shift+U".action = move-workspace-down;
            "Mod+Shift+I".action = move-workspace-up;

            "Mod+1".action = focus-workspace 1;
            "Mod+2".action = focus-workspace 2;
            "Mod+3".action = focus-workspace 3;
            "Mod+4".action = focus-workspace 4;
            "Mod+5".action = focus-workspace 5;
            "Mod+6".action = focus-workspace 6;
            "Mod+7".action = focus-workspace 7;
            "Mod+8".action = focus-workspace 8;
            "Mod+9".action = focus-workspace 9;

            "Mod+Ctrl+1".action.move-column-to-workspace = 1;
            "Mod+Ctrl+2".action.move-column-to-workspace = 2;
            "Mod+Ctrl+3".action.move-column-to-workspace = 3;
            "Mod+Ctrl+4".action.move-column-to-workspace = 4;
            "Mod+Ctrl+5".action.move-column-to-workspace = 5;
            "Mod+Ctrl+6".action.move-column-to-workspace = 6;
            "Mod+Ctrl+7".action.move-column-to-workspace = 7;
            "Mod+Ctrl+8".action.move-column-to-workspace = 8;
            "Mod+Ctrl+9".action.move-column-to-workspace = 9;

            "Mod+BracketLeft".action = consume-or-expel-window-left;
            "Mod+BracketRight".action = consume-or-expel-window-right;

            "Mod+Comma".action = consume-window-into-column;
            "Mod+Period".action = expel-window-from-column;

            "Mod+F".action = maximize-column;
            "Mod+Shift+F".action = fullscreen-window;
            "Mod+R".action = switch-preset-column-width;

            "Mod+Minus".action = set-column-width "-10%";
            "Mod+Equal".action = set-column-width "+10%";

            "Mod+Shift+Minus".action = set-window-height "-10%";
            "Mod+Shift+Equal".action = set-window-height "+10%";

            "Mod+V".action = toggle-window-floating;
            "Mod+Shift+V".action = switch-focus-between-floating-and-tiling;

            "Print".action = screenshot;
            "Ctrl+Print".action.screenshot-screen = [];
            "Alt+Print".action.screenshot-window = [];

            "Mod+Shift+E".action = quit;

            "Mod+Shift+P".action = power-off-monitors;
          }
          (lib.mkIf config.user.terminal {
            "Mod+T".action = spawn "kitty";
          })
        ];
    };

    programs.mpv.enable = cfg.mpv;
    services.swaync.enable = cfg.swaync;

    services.swayosd.enable = cfg.swayosd;
  };
}
