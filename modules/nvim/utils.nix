{ pkgs, inputs, ... }: {
  programs.nvf.settings.vim = {
    utility.yazi-nvim.enable = true;
    utility.yazi-nvim.mappings.openYazi = "<leader>ef";
    utility.yazi-nvim.mappings.openYaziDir = "<leader>ew";
    utility.yazi-nvim.mappings.yaziToggle = "<leader>ee";

    autopairs.nvim-autopairs.enable = true;

    extraPlugins = {
      "vimplugin-vim-barbaric" = {
        package = pkgs.vimUtils.buildVimPlugin {
          name = "vim-barbaric";
          src = inputs.vim-barbaric;
        };
      };
    };

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
          filter_rules.bo.filetype = [ "fidget" ];
        };
      };
    };

    mini.ai.enable = true;

    utility.motion.flash-nvim.enable = true;
    utility.motion.flash-nvim.mappings = {
      jump = "<leader>se";
      treesitter = "<leader>Se";
    };

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

    telescope.enable = true;
    telescope.mappings = {
      diagnostics = "<leader>td";
      findFiles = "<leader>tf";
      helpTags = "<leader>th";
      liveGrep = "<leader>tg";
      lspDefinitions = "<leader>tld";
      lspWorkspaceSymbols = "<leader>tls";
      lspImplementations = "<leader>tli";
      lspReferences = "<leader>tlr";
    };
    telescope.setupOpts.defaults.color_devicons = true;
  };
}
