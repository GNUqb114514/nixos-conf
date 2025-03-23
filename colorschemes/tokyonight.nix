{ pkgs, ... }: {
  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/tokyo-night-storm.yaml";

  imports = [
    ./shared.nix
  ];

  stylix.targets.neovim.enable = false;
  stylix.targets.nixvim.enable = false;

  # Neovim settings - Use out-of-box config
  programs.nixvim = {
    colorschemes.tokyonight.enable = true;
    colorscheme = "tokyonight-storm";
  };
}
