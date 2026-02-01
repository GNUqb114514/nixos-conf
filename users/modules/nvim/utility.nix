{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.user.nvim;
in {
  options.user.nvim = with lib; {
    flash = mkEnableOption "flash.nvim";
    window-picker = mkEnableOption "window-picker";
    surround = mkEnableOption "surround.nvim";
    telescope = mkEnableOption "telescope.nvim";
    oil = mkEnableOption "oil.nvim";
  };

  config.programs.nvf.settings.vim = lib.mkMerge [
    (lib.mkIf cfg.flash {
      utility.motion.flash-nvim.enable = true;
      utility.motion.flash-nvim.mappings = {
        jump = "<leader>se";
        treesitter = "<leader>Se";
      };
    })
    (lib.mkIf cfg.window-picker {
      lazy.plugins = {
        "nvim-window-picker" = rec {
          package = pkgs.vimPlugins.nvim-window-picker;
          setupModule = "window-picker";
          keys = [
            {
              mode = "n";
              key = "<leader>pw";
              action = ''
                function ()
                  local window_id = require('${setupModule}').pick_window()
                  if window_id then vim.api.nvim_set_current_win(window_id) end
                end
              '';
              lua = true;
            }
          ];
          setupOpts = {
            filter_rules.bo.filetype = ["fidget"];
          };
        };
      };
    })
    (lib.mkIf cfg.surround {
      utility.surround.enable = true;
      utility.surround.setupOpts.keymaps = {
        change = "cs";
        change_line = "cS";
        delete = "ds";
        normal = "ys";
        normal_line = "yS";
        normal_cur = "yss";
        normal_cur_line = "ySS";
      };
    })
    (lib.mkIf cfg.telescope {
      telescope.enable = true;
      telescope.mappings = lib.mkMerge [
        {
          findFiles = "<leader>tf";
          helpTags = "<leader>th";
          liveGrep = "<leader>tg";
        }
        (lib.mkIf cfg.lsp.enable {
          diagnostics = "<leader>td";
          lspDefinitions = "<leader>tld";
          lspWorkspaceSymbols = "<leader>tls";
          lspImplementations = "<leader>tli";
          lspReferences = "<leader>tlr";
        })
      ];
      telescope.setupOpts.defaults.color_devicons = true;
    })
    (lib.mkIf cfg.oil {
      utility.oil-nvim.enable = true;
    })
  ];
}
