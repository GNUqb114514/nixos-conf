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
      action = "<cmd>nohlsearch<CR>";
      key = "<Leader>nh";
      options.silent = true;
    }
    {
      options.desc = "Go to next buffer";
      action = "<cmd>bnext<CR>";
      key = "<Leader>lb";
      options.silent = true;
    }
    {
      options.desc = "Go to prev buffer";
      action = "<cmd>bprev<CR>";
      key = "<Leader>hb";
      options.silent = true;
    }
    ];
    globals = {
      mapleader = "<Space>";
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
  };
}
