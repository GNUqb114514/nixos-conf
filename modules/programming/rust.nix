{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.user.programming.rust;
in {
  options.user.programming.rust = lib.mkEnableOption "Rust programming environment";

  config = lib.mkIf cfg {
    home.packages = with pkgs; [
      rust-bin.stable.latest.default
    ];

    programs.nvf.settings.vim.languages.rust.enable = true;
  };
}
