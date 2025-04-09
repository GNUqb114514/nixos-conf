# Tokyonight theme by Folke

{ pkgs, ... }: {
  # Alacritty settings
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

  # Neovim settings - Use out-of-box config
  programs.nixvim = {
    colorschemes.tokyonight.enable = true;
    colorscheme = "tokyonight-storm";
  };

  # Fuzzy finder settings - translated by origin
  programs.fzf.colors = {
    fg = "#c0caf5";
    bg = "#24283b";
    hl = "#ff9e64";       # Orange
    "fg+" = "#c0caf5";
    "bg+" = "#292e42";
    "hl+" = "#ff9e64";    # Orange
    info = "#7aa2f7";     # Blue
    prompt = "#7dcfff";   # Cyan
    pointer = "#7dcfff";  # Cyan
    marker = "#9ece6a";   # Green
    spinner = "#9ece6a";  # Green
    header = "#9ece6a";   # Green
  };
}
