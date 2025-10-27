{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.user.fcitx;
in {
  options.user.fcitx = with lib; {
    enable = mkEnableOption "Fcitx5";
    addons = mkOption {
      type = types.listOf types.package;
      description = ''
        Addons for fcitx5.
      '';
      default = [
        fcitx5-gtk
        fcitx5-chinese-addons
        fcitx5-lua
        libsForQt5.fcitx5-configtool
      ];
    };
    settings = mkOption {
      type = types.attrs;
      description = ''
        Settings for Fcitx5.
      '';
      default = {};
    };
  };

  config = lib.mkIf cfg.enable {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          fcitx5-gtk
          fcitx5-chinese-addons
          fcitx5-lua
          kdePackages.fcitx5-configtool
        ];
        inherit (cfg) settings;
        waylandFrontend = true;
      };
    };
  };
}
