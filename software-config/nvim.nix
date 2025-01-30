{ config, pkgs, ... }: let
helpers = config.lib.nixvim;
in {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    opts = {
      # Numbers
      relativenumber = true;
      number = true;
      signcolumn = "yes";

      # Indenting
      expandtab = true;
      softtabstop = 4;
      shiftwidth = 4;

      # Searching
      hlsearch = true;
      smartcase = true;

      # Completion
      wildmenu = true;
      completeopt = [ "menuone" "popup" "noinsert" "noselect" ];

      # Appearance
      cursorline = true;
      title = true;
      exrc = true;

      # Misc
      wrap = false;
      splitright = true;
      showmode = false;
    };
    keymaps = [
      {
        options.desc = "Hide highlight for search predicate";
        action = "<Cmd>nohlsearch<CR>";
        key = "<Leader>nh";
        mode = [ "n" ];
        options.silent = true;
      }
      {
        options.desc = "Go to next buffer";
        action = "<cmd>bnext<CR>";
        key = "<Leader>lb";
        mode = [ "n" ];
        options.silent = true;
      }
      {
        options.desc = "Go to prev buffer";
        action = "<cmd>bprev<CR>";
        key = "<Leader>hb";
        mode = [ "n" ];
        options.silent = true;
      }
      {
        options.desc = "Lspsaga: Rename symbols";
        action = "<cmd>Lspsaga rename ++project<CR>";
        key = "<Leader>cn";
        mode = [ "n" ];
      }
      {
        options.desc = "Lspsaga: Apply code actions";
        action = "<cmd>Lspsaga code_action<CR>";
        key = "<Leader>aa";
        mode = [ "n" ];
      }
    ];
    globals = {
      mapleader = " ";
    };
    withRuby = false;
    colorschemes.tokyonight.enable = true;
    colorscheme = "tokyonight-night";
    plugins.cmp = {
      enable = true;
      settings.sources = let
        pplugin = name: { inherit name; };
      in [
        (pplugin "nvim-lsp")
        (pplugin "async-path")
        (pplugin "buffer")
        (pplugin "calc")
        (pplugin "conventionalcommits")
        (pplugin "emoji")
        (pplugin "spell")
      ];
    };
    plugins.compiler.enable = true;
    plugins.fzf-lua.enable = true;
    plugins.git-conflict.enable = true;
    plugins.gitblame = {
      enable = true;
      settings.enabled = false;
    };
    plugins.gitsigns.enable = true;
    plugins.indent-blankline.enable = true;
    plugins.lualine.enable = true;
    plugins.neogit.enable = true;
    plugins.web-devicons.enable = true;
    plugins.fidget.enable = true;
    plugins.treesitter = {
      enable = true;
      grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        json
          lua
          markdown
          nix
          regex
          toml
          xml
          yaml
          rust
          python
      ];
    };
    plugins.trouble.enable = true;
    plugins.lsp = {
      enable = true;
      inlayHints = true;
      servers = {
        rust_analyzer = {
          enable = true;
          package = null;
          installCargo = false;
          installRustc = false;
          installRustfmt = false;
        };
      };
    };
    plugins.lspsaga.enable = true;
  };
}
