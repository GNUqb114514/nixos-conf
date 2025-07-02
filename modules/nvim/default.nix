{
  lib,
  config,
  ...
}: let
  cfg = config.user.nvim;
in {
  options.user.nvim = with lib; {
    enable = mkEnableOption "neovim";
  };

  imports = [
    ./general.nix
    ./ui.nix
    ./utils.nix
    ./languages.nix
    ./neogit.nix
    ./completion.nix
    ./fold.nix
  ];

  config = {
    programs.nvf.enable = true;
  };
}
