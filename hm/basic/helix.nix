{ lib, config, ... }:
let
  cfg = config.user.helix;
in
{
  options.user.helix = with lib; {
    enable = mkEnableOption "helix";
    custom-theming = mkEnableOption "Custom theming instead of stylix one";
    main-color = mkOption {
      description = "The main color used in custom theming";
      default = "base09";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        programs.helix.enable = true;
      }
      (lib.mkIf cfg.custom-theming {
        programs.helix.settings.theme = lib.mkForce "custom";
        programs.helix.themes.custom = {
          inherits = "stylix";
          "ui.linenr.selected" = {
            fg = cfg.main-color;
          };
          "ui.picker.header" = {
            fg = cfg.main-color;
          };
          "ui.text.focus" = {
            fg = cfg.main-color;
          };
          "ui.statusline.normal" = {
            fg = cfg.main-color;
          };
          "ui.statusline.insert" = {
            fg = cfg.main-color;
          };
          "ui.statusline.select" = {
            fg = cfg.main-color;
          };
        };
      })
    ]
  );
}
