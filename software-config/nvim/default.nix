{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    # Clipboard provider
    wl-clipboard
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
        beforeAll = ''
          vim.keymap.set('n','<leader>pw', function ()
            local window_number = require('${setupModule}').pick_window()
            if window_number then vim.api.nvim_set_current_win(window_number) end
          end)
        '';
        setupOpts = {
          filter_rules.bo.filetype = "fidget";
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
      "leap.nvim" = {
        package = pkgs.vimPlugins.leap-nvim;
        after = ''
          local map = vim.keymap
          map.set('n', '<Leader>le', '<Plug>(leap)');
          map.set('n', '<Leader>Le', '<Plug>(leap-anywhere)');
        '';
      };
      "vimplugin-leap-zh.nvim" = {
        package = pkgs.vimUtils.buildVimPlugin rec {
          name = "leap-zh.nvim";
          src = pkgs.fetchFromGitHub {
            owner = "noearc";
            repo = "${name}";
            rev = "1fdb57d18c9a3dabc4dfbd69cd80ff8dff0529ea";
            hash = "sha256-xmUTZHe6Swhrb0n5/r/f6Dfhec1tWvjNyu5zeRw0RnA=";
          };
          dependencies = [
            (pkgs.vimUtils.buildVimPlugin rec {
              name = "jieba-lua";
              src = pkgs.fetchFromGitHub {
                owner = "noearc";
                repo = "${name}";
                rev = "20e0b9e0eeb2ce92819e1335f6e2357d87ee78ca";
                hash = "sha256-p6Y8UZAodS9eiaCoPDUq1pzxkHpcjuWy1orwL9WbwoU=";
              };
            })
          ];
        };
        after = ''
          local map = vim.keymap
          map.set('n', '<Leader>lc', require('leap-zh').leap_zh_all());
        '';
      };
    };

    mini.ai.enable = true;

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
