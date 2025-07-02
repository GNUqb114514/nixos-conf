{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  cfg = config.user.nvim;
in {
  options.user.nvim = with lib; {
    enable = mkEnableOption "neovim";
    exrc = mkEnableOption "exrc";
    yazi = mkEnableOption "yazi.nvim";
    window-picker = mkEnableOption "window-picker";
    flash = mkEnableOption "flash.nvim";
    surround = mkEnableOption "surround.nvim";
    telescope = mkEnableOption "telescope.nvim";
    lsp = {
      enable = mkEnableOption "LSP support";
      saga = mkEnableOption "Lspsaga";
    };
    extraProgrammingSupport = mkEnableOption "extra programming support";
    trouble = mkEnableOption "trouble.nvim (diagnistics support)";
    neogit = mkEnableOption "neogit";
    completion = {
      enable = mkEnableOption "blink.cmp";
      snippets = mkEnableOption "snippet support";
      lazydev = mkEnableOption "lazydev";
    };
    fold = mkEnableOption "fold enhancement";
  };

  config = lib.mkIf cfg.enable {
    warnings =
      lib.optionals (cfg.yazi && !config.user.shell.utilities.tui) ["Yazi.nvim requires TUI softwares"]
      ++ lib.optionals (cfg.trouble && !cfg.lsp.enable) ["trouble.nvim requires LSP"]
      ++ lib.optionals (cfg.completion.lazydev && !config.user.programming.lua) ["Lazydev requires lua programmming environment."];

    # Add clipboard provider
    home.packages = with pkgs; [wl-clipboard];

    programs.neovim.enable = true;
    programs.neovim.defaultEditor = true;

    programs.nvf.enable = true;

    programs.nvf.settings.vim = lib.mkMerge [
      {
        globals.mapleader = " ";

        lineNumberMode = "relNumber";
        searchCase = "smart";
        options = {
          cursorlineopt = "both";
          cursorline = true;
          inherit (cfg) exrc;
          wrap = false;
          showmode = false;
        };

        # Automatic shiftwidth changing
        utility.sleuth.enable = true;

        keymaps = [
          {
            key = "<leader>nh";
            mode = "n";
            action = "<cmd>nohlsearch<CR>";
          }
        ];

        autopairs.nvim-autopairs.enable = true;

        mini.ai.enable = true;
      }
      (lib.mkIf config.user.terminal {
        options.title = true;
        # Status line
        statusline.lualine = {
          enable = true;
          disabledFiletypes = ["sagaoutline"];
        };

        # Indent
        visuals.indent-blankline.enable = true;

        # Notify
        notify.nvim-notify.enable = true;
        options.termguicolors = true;
      })
      (lib.mkIf config.user.fcitx.enable {
        extraPlugins = {
          "vimplugin-vim-barbaric" = {
            package = pkgs.vimUtils.buildVimPlugin {
              name = "vim-barbaric";
              src = inputs.vim-barbaric;
            };
          };
        };

        lazy.plugins = {
          "vimplugin-nerdicons.nvim" = {
            package = pkgs.vimUtils.buildVimPlugin rec {
              name = "nerdicons.nvim";
              src = inputs.nerdicons-nvim;
            };
            setupModule = "nerdicons";
            cmd = ["NerdIcons"];
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
      (lib.mkIf cfg.flash {
        utility.motion.flash-nvim.enable = true;
        utility.motion.flash-nvim.mappings = {
          jump = "<leader>se";
          treesitter = "<leader>Se";
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
            diagnostics = "<leader>td";
            findFiles = "<leader>tf";
            helpTags = "<leader>th";
            liveGrep = "<leader>tg";
          }
          (lib.mkIf cfg.lsp.enable {
            lspDefinitions = "<leader>tld";
            lspWorkspaceSymbols = "<leader>tls";
            lspImplementations = "<leader>tli";
            lspReferences = "<leader>tlr";
          })
        ];
        telescope.setupOpts.defaults.color_devicons = true;
      })
      (lib.mkIf cfg.lsp.enable (lib.mkMerge [
        {
          lsp.enable = true;

          lsp.inlayHints.enable = true;
          keymaps = [
            {
              key = "<leader>it";
              mode = "n";
              action = ''
                function ()
                  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled
                    {bufnr = vim.api.nvim_get_current_buf()})
                end
              '';
              lua = true;
            }
          ];

          diagnostics.enable = true;
          diagnostics.config.virtual_text = true;
        }
        (lib.mkIf cfg.lsp.saga {
          lsp.lspsaga = {
            enable = true;
          };

          keymaps = [
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
              action = "<cmd>Lspsaga peek_definition<CR>";
            }
            {
              key = "<leader>pD";
              mode = "n";
              action = "<cmd>Lspsaga peek_type_definition<CR>";
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
        })
      ]))
      (lib.mkIf cfg.trouble {
        lsp.trouble.enable = true;
        lsp.trouble.mappings = {
          workspaceDiagnostics = "<leader>dw";
          documentDiagnostics = "<leader>df";
        };
      })
      (lib.mkIf cfg.extraProgrammingSupport {
        languages = {
          enableDAP = true;
          enableExtraDiagnostics = true;
          enableFormat = true;
          enableTreesitter = true;
        };
        treesitter = {
          enable = true;
          autotagHtml = true;
          fold = true;
          grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
            latex
          ];
        };
      })
      (lib.mkIf cfg.neogit {
        lazy.plugins = {
          "neogit" = {
            package = pkgs.vimPlugins.neogit;
            cmd = ["Neogit"];
          };
          "diffview.nvim" = {
            package = pkgs.vimPlugins.diffview-nvim;
            setupOpts.keymaps.file_panel = [["n" "q" "<cmd>tabclose<CR>"]];
          };
        };
      })
      (lib.mkIf cfg.completion.enable {
        autocomplete.blink-cmp = {
          enable = true;
          friendly-snippets.enable = cfg.completion.snippets;
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
            sources = lib.mkMerge [
              (lib.mkIf cfg.completion.lazydev {
                default = lib.mkBefore ["lazydev"];
                providers.lazydev = {
                  name = "LazyDev";
                  module = "lazydev.integrations.blink";
                  score_offset = 100;
                };
              })
            ];
            fuzzy.implementation = "prefer_rust_with_warning";
          };
        };
      })
      (lib.mkIf cfg.completion.lazydev {
        languages = {
          lua.lsp.lazydev.enable = true;
        };
      })
      (lib.mkIf cfg.fold (lib.mkMerge [
        {
          options.foldlevelstart = 99;
          options.foldmethod = "expr";
          options.foldexpr = "v:lua.vim.treesitter.foldexpr()";

          highlight."Folded" = {
            fg = config.lib.stylix.colors.withHashtag.orange;
          };
        }
        (lib.mkIf config.user.terminal {
          luaConfigRC = {
            foldtext = inputs.nvf.lib.nvim.dag.entryBefore ["optionsScript"] (builtins.readFile ./fold_virt_text.lua);
          };
          options.fillchars = "fold: ,foldopen:,foldclose:";

          options.foldtext = "v:lua.custom_foldtext()";
        })
        (lib.mkIf cfg.lsp.enable {
          autocmds = [
            {
              event = ["LspAttach"];
              # group = "fold";
              callback = lib.generators.mkLuaInline ''
                function(event)
                  local client = vim.lsp.get_client_by_id(event.data.client_id)
                  if client and client:supports_method 'text_document/foldingRange' then
                    local win = vim.api.nvim_get_current_win()
                    vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
                  end
                end
              '';
            }
          ];
        })
      ]))
    ];
  };
}
