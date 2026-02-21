{
  lib,
  config,
  ...
}:
let
  cfg = config.user.de.quickshell;
in
{
  options.user.de.quickshell = with lib; {
    enable = mkEnableOption "Quickshell";
    activeConfig = mkOption {
      type = types.string;
      description = "Active config of quickshell";
    };
  };

  config.programs.quickshell = lib.mkIf cfg.enable {
    inherit (cfg) activeConfig;
    enable = true;
    configs = builtins.mapAttrs (name: _: ./quickshell-configs/${name}) (
      builtins.readDir ./quickshell-configs
    );
  };
}
