{ pkgs, ... }: {
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-storm.yaml";

  imports = [
    ./shared.nix
  ];

  # Neovim settings - Use out-of-box config
  stylix.targets.neovim.enable = false;
  # stylix.targets.nvf.enable = false;

  # Alacritty settings - stylix for alacritty is broken
  stylix.targets.alacritty.enable = false;
  programs.alacritty.settings = {
    colors = {
      bright = {
        black = "#444b6a";
        blue = "#7da6ff";
        cyan = "#0db9d7";
        green = "#b9f27c";
        magenta = "#bb9af7";
        red = "#ff7a93";
        white = "#acb0d0";
        yellow = "#ff9e64";
      };
      normal = {
        black = "#32344a";
        blue = "#7aa2f7";
        cyan = "#449dab";
        green = "#9ece6a";
        magenta = "#ad8ee6";
        red = "#f7768e";
        white = "#9699a8";
        yellow = "#e0af68";
      };
      primary = {
        background = "#24283b";
        foreground = "#a9b1d6";
      };
    };
  };

  # Starship settings - stylix for starship is broken
  stylix.targets.starship.enable = false;
  programs.starship.settings.palette = "tokyonight";
  programs.starship.settings.palettes.tokyonight = {
    bright-black = "#444b6a";
    bright-red = "#ff7a93";
    bright-green = "#b9f27c";
    bright-blue = "#7da6ff";
    bright-yellow = "#ff9e64";
    bright-purple = "#bb9af7";
    bright-cyan = "#0db9d7";
    bright-white = "#acb0d0";

    black = "#32344a";
    red = "#f7768e";
    green = "#9ece6a";
    blue = "#7aa2f7";
    yellow = "#e0af68";
    purple = "#ad8ee6";
    cyan = "#449dab";
    white = "#9699a8";
  };
}
