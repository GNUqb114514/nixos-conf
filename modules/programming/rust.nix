{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.user.programming.rust;
in {
  options.user.programming.rust = lib.mkEnableOption "Rust programming environment";

  config = lib.mkIf cfg {
    home.packages = with pkgs; [
      cargo
      rustc
      rustfmt
      clippy
    ];

    programs.nvf.settings.vim.languages.rust.enable = true;
  };
}
