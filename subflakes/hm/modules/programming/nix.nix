{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.user.programming.nix;
in
{
  options.user.programming.nix = lib.mkEnableOption "Nix programming environment";

  config = lib.mkIf cfg {
    programs.nvf.settings.vim.languages = {
      nix.enable = true;
      nix.lsp.servers = [ "nixd" ];
    };
  };
}
