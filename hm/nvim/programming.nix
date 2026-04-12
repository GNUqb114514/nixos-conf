{
  pkgs,
  config,
  lib,
  input,
  ...
}:
let
  cfg = config.user.nvim;
in
{
  options.user.nvim = with lib; {
    lsp = {
      enable = mkEnableOption "LSP support";
      saga = mkEnableOption "Lspsaga";
    };
    extraProgrammingSupport = mkEnableOption "extra programming support";

    trouble = mkEnableOption "trouble.nvim (diagnistics support)";
  };
  config.warnings = lib.optionals (cfg.trouble && !cfg.lsp.enable) [ "trouble.nvim requires LSP" ];

  config.programs.nvf.settings.vim = lib.mkMerge [
    (lib.mkIf cfg.lsp.enable (
      lib.mkMerge [
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
      ]
    ))
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
  ];
}
