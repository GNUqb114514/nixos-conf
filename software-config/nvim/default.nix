{ ... }: {
  imports = [
    ./general.nix
    ./ui.nix
    ./utils.nix
    ./languages.nix
    ./neogit.nix
    ./completion.nix
    ./fold.nix
  ];

  programs.nvf.enable = true;
}
