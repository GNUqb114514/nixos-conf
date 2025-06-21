{config, pkgs, inputs, ...}: {
  home.username = "qb114514";
  home.homeDirectory = "/home/qb114514";

  programs.git = {
    enable = true;
    userName = "qb114514";
    userEmail = "GNUqb114514@outlook.com";
  };

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  imports = [
    inputs.niri-flake.homeModules.stylix
    inputs.niri-flake.homeModules.niri
    inputs.nvf.homeManagerModules.default
    inputs.stylix.homeModules.stylix
    ./software-config
    ./colorschemes/catppuccin-mocha.nix
  ];
}
