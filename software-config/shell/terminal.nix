{ pkgs, ... }: {
  programs.alacritty.enable = true;

  programs.alacritty.settings = {
    font = {
      size = 13;
    };

    window = {
      decorations = "None";
    };
  };
}
