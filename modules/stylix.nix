{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.user.stylix;
in {
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
    stylix.fonts = let
      font = name: package: {inherit name package;};
    in
      with pkgs; {
        monospace = font "UbuntuMono Nerd Font" nerd-fonts.ubuntu-mono;
        sansSerif = font "Ubuntu Nerd Font" nerd-fonts.ubuntu;
        serif = font "Source Han Serif SC" source-han-serif-simplified-chinese;
        sizes = let
          normal = 13;
          small = 12;
          large = 15;
        in {
          terminal = normal;
          applications = normal;
          desktop = small;
          popups = small;
        };
      };

    stylix.targets.firefox.profileNames = ["default"];

    stylix.base16Scheme = lib.mkIf (cfg.colorscheme != null) "${pkgs.base16-schemes}/share/themes/${cfg.colorscheme}.yaml";

    stylix.image = cfg.wallpaper;
  };
}
