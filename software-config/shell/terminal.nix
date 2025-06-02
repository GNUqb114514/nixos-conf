{ ... }: {
  programs.alacritty.enable = true;
  programs.kitty.enable = true;

  programs.kitty.settings = {
    text_composition_strategy = "legacy";
  };

  programs.alacritty.settings = {
    font = {
      size = 13;
    };

    window = {
      decorations = "None";
    };
  };
}
