{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.user.nvim;
  inputs = config.user.inputs;
in
{
  options.user.nvim = with lib; {
    yazi = mkEnableOption "yazi.nvim";
  };
  config.warnings = lib.optionals (cfg.yazi && !config.user.shell.utilities.tui) [
    "Yazi.nvim requires TUI softwares"
  ];
  config.programs.nvf.settings.vim = lib.mkMerge [
    (lib.mkIf config.user.terminal {
      options.title = true;
      # Status line
      statusline.lualine = {
        enable = true;
        disabledFiletypes = [ "sagaoutline" ];
      };

      # Indent
      visuals.indent-blankline.enable = true;

      # Notify
      notify.nvim-notify.enable = true;
      options.termguicolors = true;

      lazy.plugins = {
        "vimplugin-nerdicons.nvim" = {
          package = pkgs.vimUtils.buildVimPlugin {
            name = "nerdicons.nvim";
            src = inputs.nerdicons-nvim;
          };
          setupModule = "nerdicons";
          cmd = [ "NerdIcons" ];
        };
      };

      visuals.fidget-nvim.enable = true;
    })
    (lib.mkIf cfg.yazi {
      utility.yazi-nvim = {
        enable = true;
        mappings = {
          openYazi = "<leader>ef";
          openYaziDir = "<leader>ew";
          yaziToggle = "<leader>ee";
        };
      };
    })
  ];
}
