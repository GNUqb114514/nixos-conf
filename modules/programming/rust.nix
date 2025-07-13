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
      inotify-tools
      rustup
      gcc
      dioxus-cli
    ];

    programs.nvf.settings.vim.languages.rust.enable = true;
  };
}
