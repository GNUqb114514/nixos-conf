{ pkgs, ... }: {
  home.packages = with pkgs; [
    inotify-tools
  ];

  programs.nvf.settings.vim = {
    lsp.enable = true;

    lsp.trouble.enable = true;
    lsp.trouble.mappings = {
      workspaceDiagnostics = "<leader>dw";
      documentDiagnostics = "<leader>df";
    };

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

    treesitter = {
      enable = true;
      autotagHtml = true;
      fold = true;
      grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        latex
      ];
    };
  };
}
