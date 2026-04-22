{ config, lib, ... }: let
  cfg = config.user.idle;
in {
  options.user.idle = with lib; {
    enable = mkEnableOption "Idle management by swayidle";
    idleTime = mkOption {
      type = types.int;
      description = "The time it takes for the session to be considered idle, in seconds.";
      default = 30;
    };
    lockTime = mkOption {
      type = types.int;
      description = "The time it takes for the session to be locked, in seconds.";
      default = 3 * 60;
    };
    sleepTime = mkOption {
      type = types.int;
      description = "The time it takes for the session to sleep, in seconds.";
      default = 5 * 60;
    };
  };
  
  config = lib.mkIf cfg.enable {
    services.swayidle = {
      enable = true;
      extraArgs = [ "-w" "idlehint" (builtins.toString cfg.idleTime) ];
      events = { lock = "swaylock -f"; };
      timeouts = [
        {
          timeout = cfg.lockTime;
          command = "swaylock -f";
        }
        {
          timeout = cfg.sleepTime;
          command = "systemctl hybrid-sleep";
        }
      ];
    };
  };
}
