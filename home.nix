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
    inputs.nixvim.homeManagerModules.nixvim
    ./software-config
    colorschemes/tokyonight.nix
  ];
}
