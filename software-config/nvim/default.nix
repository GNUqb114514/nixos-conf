{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    # Clipboard provider
    wl-clipboard
    inotify-tools
  ];

  # xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "/home/qb114514/nixos-conf/software-config/nvim/";

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  programs.nvf.enable = true;
  programs.nvf.settings.vim = {
    globals.mapleader = " ";
    utility.sleuth.enable = true;
    lineNumberMode = "relNumber";
    searchCase = "smart";
    options = {
      cursorlineopt = "both";
      cursorline = true;
      title = true;
      exrc = true;
      wrap = false;
      showmode = false;
      termguicolors = true;
    };

    statusline.lualine = {
      enable = true;
      disabledFiletypes = ["sagaoutline"];
    };

    utility.yazi-nvim.enable = true;
    utility.yazi-nvim.mappings.openYazi = "<leader>ef";
    utility.yazi-nvim.mappings.openYaziDir = "<leader>ew";
    utility.yazi-nvim.mappings.yaziToggle = "<leader>ee";

    tabline.nvimBufferline.enable = true;
    tabline.nvimBufferline.setupOpts.options.modified_icon = "•";

    visuals.indent-blankline.enable = true;

    lsp.trouble.enable = true;
    lsp.trouble.mappings = {
      workspaceDiagnostics = "<leader>dd";
      documentDiagnostics = "<leader>dd";
    };

    notify.nvim-notify.enable = true;
    autopairs.nvim-autopairs.enable = true;

    extraPlugins = {
      "vimplugin-vim-barbaric" = {
        package = pkgs.vimUtils.buildVimPlugin rec {
          name = "vim-barbaric";
          src = pkgs.fetchFromGitHub {
            owner = "rlue";
            repo = "${name}";
            rev = "7a7084f0a7352528b5785eb411b0cf68bbb07f8d";
            hash = "sha256-9wFyqL0gekG7IBKAQdWv7JjfUQsoJA60wzAqRWnQuN8=";
          };
        };
      };
      "vim-repeat" = {
        package = pkgs.vimPlugins.vim-repeat;
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
      "neogit" = {
        package = pkgs.vimPlugins.neogit;
        cmd = ["Neogit"];
      };
      "diffview.nvim" = {
        package = pkgs.vimPlugins.diffview-nvim;
        setupOpts.keymaps.file_panel = [["n" "q" "<cmd>tabclose<CR>"]];
      };
      "vimplugin-nerdicons.nvim" = {
        package = pkgs.vimUtils.buildVimPlugin rec {
          name = "nerdicons.nvim";
          src = pkgs.fetchFromGitHub {
            owner = "nvimdev";
            repo = "${name}";
            rev = "2d257ff9b00b7d1510704e0a565a6a7ede76b79a";
            hash = "sha256-cAaIcF7Z4NmSugaIzSTKzmjEI7YXZoAY8rxi5D3zua0=";
          };
        };
        setupModule = "nerdicons";
        cmd = ["NerdIcons"];
      };
      # "vimplugin-flash-zh.nvim" = {
      #   package = pkgs.vimUtils.buildVimPlugin rec {
      #     name = "flash-zh.nvim";
      #     src = pkgs.fetchFromGitHub {
      #       owner = "rainzm";
      #       repo = name;
      #       rev = "3a1ac81b5de47c568b640e5a096cf63b00847496";
      #       hash = "sha256-R8PdEAhi1q1ieYV+q7TLcEPkA4TlTaiuxhHp1dF5qHI=";
      #     };
      #     nvimSkipModules = [ "flash-zh" ];
      #   };
      #   keys = [
      #     {
      #       mode = [ "n" ];
      #       key = "<leader>sc";
      #       action = "function() require('flash-zh').jump({ chinese_only = false }) end";
      #     }
      #   ];
      # };
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

    lsp.enable = true;
    lsp.mappings.openDiagnosticFloat = null;

    languages = {
      enableDAP = true;
      enableExtraDiagnostics = true;
      enableFormat = true;
      enableTreesitter = true;

      typst.enable = true;
      nix.enable = true;
      nix.lsp.server = "nixd";
      lua.enable = true;
      lua.lsp.lazydev.enable = true;
      markdown.enable = true;
      markdown.format.enable = false;
      markdown.lsp.package = ["${pkgs.markdown-oxide}/bin/markdown-oxide"];
    };

    treesitter = {
      enable = true;
      autotagHtml = true;
      fold = true;
      grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        latex
      ];
    };

    visuals.fidget-nvim.enable = true;

    lsp.lspsaga = {
      enable = true;
    };

    autocomplete.blink-cmp = {
      enable = true;
      friendly-snippets.enable = true;
      mappings = {
        scrollDocsUp = "<M-k>";
        scrollDocsDown = "<M-j>";
      };
      setupOpts = {
        appearance = {
          nerd_font_variant = "normal";
        };
        keymap = {
          "<Esc>" = [
            (lib.generators.mkLuaInline ''
              function (cmp)
                if cmp.snippet_active() then return cmp.hide()
                else return end
              end
            '')
            "fallback"
          ];
        };
        sources = {
          default = lib.mkBefore ["lazydev"];
          providers.lazydev = {
            name = "LazyDev";
            module = "lazydev.integrations.blink";
            score_offset = 100;
          };
        };
        fuzzy.implementation = "prefer_rust_with_warning";
      };
    };

    # languages.markdown.extensions.render-markdown-nvim = {
    #   enable = true;
    #   setupOpts = {
    #     heading.icons = {};
    #     bullet.icons = ["•" "∘" "⬥" "⬦"];
    #     completions.blink.enabled = true;
    #   };
    # };

    languages.markdown.extensions.markview-nvim = {
      enable = true;
      setupOpts = {};
    };

    keymaps = [
      {
        key = "<leader>nh";
        mode = "n";
        action = "<cmd>nohlsearch<CR>";
      }
      {
        key = "gd";
        mode = "n";
        action = "<cmd>Lspsaga goto_definition<CR>";
      }
      {
        key = "gD";
        mode = "n";
        action = "<cmd>Lspsaga goto_type_definition<CR>";
      }
      {
        key = "<leader>pd";
        mode = "n";
        action = "<cmd>Lspsaga goto_definition<CR>";
      }
      {
        key = "<leader>pD";
        mode = "n";
        action = "<cmd>Lspsaga goto_type_definition<CR>";
      }
      {
        key = "K";
        mode = "n";
        action = "<cmd>Lspsaga hover_doc<CR>";
      }
      {
        key = "<leader>vo";
        mode = "n";
        action = "<cmd>Lspsaga outline<CR>";
      }
      {
        key = "<leader>rn";
        mode = "n";
        action = "<cmd>Lspsaga lsp_rename<CR>";
      }
      {
        key = "<leader>rN";
        mode = "n";
        action = "<cmd>Lspsaga lsp_rename mode=n<CR>";
      }
    ];
  };
}
