{pkgs, config, lib, ...}: let
  cfg = config.user.programming.cpp;
in {
  options.user.programming.cpp = lib.mkEnableOption "C++ environment";

  config = lib.mkIf cfg {
    home.packages = with pkgs; [
      gcc
    ];

    programs.nvf.settings.vim.languages.clang = {
      enable = true;
      dap.enable = true;
    };
  };
}
