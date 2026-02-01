{ config, lib, ... }: let
  cfg = config.user.waybar;
in {
  options.user.waybar = with lib; {
    enable = mkEnableOption "Waybar";
    custom-css = mkEnableOption "self-made CSS for Waybar instead of Stylix-provided one";
    interval = mkOption {
      type = types.int;
      description = ''
        The interval for pooling.

        Affects CPU, memory, etc.
      '';
      example = 1;
      default = 3;
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      programs.waybar.enable = true;
      programs.waybar.systemd.enable = true;
      programs.waybar.settings.mainBar = {
        modules-left = [ "niri/workspaces" ];
        modules-center = [ "niri/window" ];
        modules-right = [ "cpu" "memory" "battery" "clock" "tray" ];
        "niri/window" = {
          separate-outputs = true;
        };
        "cpu" = {
          format = "{usage}%  ";
          interval = cfg.interval;
          states = {
            high = 80;
          };
        };
        "memory" = {
          format = "{percentage}%  ";
          interval = cfg.interval;
          states = {
            high = 80;
          };
        };
        "battery" = {
          format = "{capacity}% {icon}";
          format-plugged = "{capacity}% {icon}  ";
          format-charging = "{capacity}% {icon} 󱐋";
          format-time = "{H}h{M}m";
          tooltip-format = "{timeTo}\n{power}W draw";
          format-icons = [" " " " " " " " " "];
          states = {
            empty = 0;
            twenty = 20;
            forty = 40;
            sixty = 60;
            eighty = 80;
          };
        };
        "clock" = {
          format = "{:%R}";
          format-alt = "{:%x %a}";
          tooltip = false;
        };
      };
    }
    (lib.mkIf cfg.custom-css {
      stylix.targets.waybar.addCss = false;
      programs.waybar.style = lib.mkAfter (builtins.readFile ./waybar.css);
    })
  ]);
}

