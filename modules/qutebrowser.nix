{
  lib,
  config,
  ...
}: let
  cfg = config.user.qutebrowser;
in {
  options.user.qutebrowser = with lib; {
    enable = mkEnableOption "Qutebrowser";
    disable-gpu = mkOption {
      type = types.bool;
      description = ''
        Disable GPU acceleration to avoid some errors.
      '';
      default = false;
    };
  };

  config = lib.mkIf cfg.enable {
    programs.qutebrowser = {
      enable = true;
      settings = {
        qt.args = lib.mkIf cfg.disable-gpu ["disable-gpu"];
        editor.command = ["kitty" "nvim" "+call cursor({line}, {column})" "--" "{file}"];
      };
    };
  };
}
