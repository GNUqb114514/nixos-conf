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
    enable = mkEnableOption "neovim";
    exrc = mkEnableOption "exrc";
    neogit = mkEnableOption "neogit";
    fold = mkEnableOption "fold enhancement";
  };

  imports = [
    ./graphical.nix
    ./utility.nix
    ./programming.nix
    ./completion.nix
  ];

  config = lib.mkIf cfg.enable {
    # Add clipboard provider
    home.packages = with pkgs; [ wl-clipboard ];

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
      (lib.mkIf config.user.fcitx.enable {
        extraPlugins = {
          "vimplugin-vim-barbaric" = {
            package = pkgs.vimUtils.buildVimPlugin {
              name = "vim-barbaric";
              src = inputs.vim-barbaric;
            };
          };
        };
      })
      (lib.mkIf cfg.neogit {
        lazy.plugins = {
          "neogit" = {
            package = pkgs.vimPlugins.neogit;
            cmd = [ "Neogit" ];
          };
          "diffview.nvim" = {
            package = pkgs.vimPlugins.diffview-nvim;
            setupOpts.keymaps.file_panel = [
              [
                "n"
                "q"
                "<cmd>tabclose<CR>"
              ]
            ];
          };
        };
      })
      (lib.mkIf cfg.fold (
        lib.mkMerge [
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
              foldtext = inputs.nvf.lib.nvim.dag.entryBefore [ "optionsScript" ] (
                builtins.readFile ./fold_virt_text.lua
              );
            };
            options.fillchars = "fold: ,foldopen:,foldclose:";

            options.foldtext = "v:lua.custom_foldtext()";
          })
          (lib.mkIf cfg.lsp.enable {
            autocmds = [
              {
                event = [ "LspAttach" ];
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
        ]
      ))
    ];
  };
}
