{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.user.programming.lua;
in {
  options.user.programming.lua = lib.mkEnableOption "Lua programming environment";

  config = lib.mkIf cfg {
    programs.nvf.settings.vim.languages = {
      lua.enable = true;
    };
  };
}
