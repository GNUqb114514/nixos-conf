{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.user.stylix;
  user-pkgs = import ../../packages { inherit pkgs; };
in
{
  options.user.stylix = with lib; {
    enable = mkEnableOption "stylix configurations";
    colorscheme = mkOption {
      type = types.nullOr types.str;
      description = ''
        The name of the colorscheme. Should be the same as in pkgs.base16-schemes.

        Setting to null will cause stylix to generate a colorscheme by itself.
      '';
      example = "catppuccin-mocha";
      default = null;
    };
    polarity = mkOption {
      type = types.str;
      description = ''
        The polarity of the colorscheme.
      '';
      default = "dark";
    };
    wallpaper = mkOption {
      type = types.nullOr types.path;
      description = ''
        The wallpaper.

        Will be used to generate colorscheme if user.stylix.colorscheme is null.
      '';
      default = null;
    };
  };

  config = lib.mkIf cfg.enable {
    stylix.enable = true;
    stylix.fonts =
      let
        font = name: package: { inherit name package; };

        maple-mono-custom-build = user-pkgs.maple-font-custom-build;
      in
      with pkgs;
      {
        monospace = font "Maple Mono NF" maple-mono-custom-build;
        sansSerif = font "Ubuntu Nerd Font" nerd-fonts.ubuntu;
        serif = font "Source Han Serif SC" source-han-serif;
        sizes =
          let
            normal = 13;
            small = 12;
            large = 15;
          in
          {
            terminal = normal;
            applications = normal;
            desktop = small;
            popups = small;
          };
      };

    stylix.polarity = cfg.polarity;

    stylix.icons = with pkgs; {
      enable = true;
      package = kora-icon-theme;
      dark = "kora";
      light = "kora-light-panel";
      # package = papirus-icon-theme;
      # dark = "Papirus-Dark";
      # light = "Papirus-Light";
    };

    stylix.cursor = with pkgs; {
      package = everforest-cursors;
      name = "everforest-cursors";
      size = 24;
    };

    stylix.targets.firefox.profileNames = [ "default" ];

    stylix.base16Scheme = lib.mkIf (
      cfg.colorscheme != null
    ) "${pkgs.base16-schemes}/share/themes/${cfg.colorscheme}.yaml";

    stylix.image = cfg.wallpaper;
  };
}
