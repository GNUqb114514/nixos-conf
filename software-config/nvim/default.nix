{ config, pkgs, ... }: let
  helpers = config.lib.nixvim;
in {
  home.packages = with pkgs; [
    # Clipboard provider
    wl-clipboard
  ];

  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink "/home/qb114514/nixos-conf/software-config/nvim/";

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;
  # programs.neovim.viAlias = true;
  # programs.neovim.vimAlias = true;

  # programs.nixvim = {
  #   extraConfigLuaPost = ''
  #     require('lzn-auto-require').enable()
  #   '';
  #
  #   enable = true;
  #   defaultEditor = true;
  #   opts = {
  #     # Numbers
  #     relativenumber = true;
  #     number = true;
  #     signcolumn = "yes";
  #
  #     # Indenting
  #     expandtab = true;
  #     softtabstop = 4;
  #     shiftwidth = 4;
  #
  #     # Searching
  #     hlsearch = true;
  #     smartcase = true;
  #
  #     # Completion
  #     wildmenu = true;
  #     completeopt = [ "menuone" "popup" "noinsert" "noselect" ];
  #
  #     # Appearance
  #     cursorline = true;
  #     title = true;
  #     exrc = true;
  #
  #     # Misc
  #     wrap = false;
  #     splitright = true;
  #     showmode = false;
  #   };
  #   files."ftplugin/nix.lua".opts = {
  #     softtabstop = 2;
  #     shiftwidth = 2;
  #   };
  #   keymaps = let
  #     command = cmd: "<cmd>${cmd}<CR>";
  #   in [
  #     {
  #       options.desc = "Hide highlight for search predicate";
  #       action = command "nohlsearch";
  #       key = "<Leader>nh";
  #       mode = [ "n" ];
  #       options.silent = true;
  #     }
  #     {
  #       options.desc = "Go to next buffer";
  #       action = command "bnext";
  #       key = "<Leader>lb";
  #       mode = [ "n" ];
  #       options.silent = true;
  #     }
  #     {
  #       options.desc = "Go to prev buffer";
  #       action = command "bprev";
  #       key = "<Leader>hb";
  #       mode = [ "n" ];
  #       options.silent = true;
  #     }
  #     {
  #       options.desc = "Lspsaga: Rename symbols";
  #       action = command "Lspsaga rename ++project";
  #       key = "<Leader>cn";
  #       mode = [ "n" ];
  #     }
  #     {
  #       options.desc = "Lspsaga: Apply code actions";
  #       action = command "Lspsaga code_action";
  #       key = "<Leader>aa";
  #       mode = [ "n" ];
  #     }
  #     {
  #       options.desc = "Activate Yazi";
  #       action = command "Yazi";
  #       key = "<Leader>e";
  #       mode = [ "n" ];
  #     }
  #   ];
  #   globals = {
  #     mapleader = " ";
  #   };
  #   withRuby = false;
  #   plugins.cmp = {
  #     lazyLoad.settings.event = "BufRead";
  #     autoLoad = false;
  #     enable = true;
  #     settings.sources = let
  #       pplugin = name: { inherit name; };
  #     in [
  #       (pplugin "nvim_lsp")
  #       (pplugin "path")
  #       (pplugin "buffer")
  #       (pplugin "calc")
  #       (pplugin "conventionalcommits")
  #       (pplugin "emoji")
  #       (pplugin "spell")
  #     ];
  #     settings.mapping = {
  #       "<CR>" = "cmp.mapping.confirm({ select = True })";
  #       "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
  #       "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
  #       "<C-d>" = "cmp.mapping.scroll_docs(-4)";
  #       "<C-f>" = "cmp.mapping.scroll_docs(4)";
  #     };
  #   };
  #   plugins.lz-n.enable = true;
  #   plugins.fzf-lua = {
  #     enable = true;
  #     lazyLoad.settings.cmd = "FzfLua";
  #   };
  #   plugins.git-conflict.enable = true;
  #   plugins.gitblame = {
  #     enable = true;
  #     settings.enabled = false;
  #     lazyLoad.settings.event = "BufRead";
  #   };
  #   plugins.gitsigns = {
  #     lazyLoad.settings.event = "BufRead";
  #     enable = true;
  #   };
  #   plugins.indent-blankline = {
  #     lazyLoad.settings.event = "BufRead";
  #     enable = true;
  #   };
  #   plugins.lualine.enable = true;
  #   plugins.neogit = {
  #     enable = true;
  #     lazyLoad.settings.cmd = "Neogit";
  #   };
  #   # Required by neogit
  #   plugins.diffview = {
  #     enable = true;
  #     keymaps.filePanel = [
  #       {
  #         action = "<cmd>tabclose<CR>";
  #         description = "Close diffview";
  #         key = "q";
  #         mode = "n";
  #       }
  #     ];
  #   };
  #   plugins.web-devicons.enable = true;
  #   plugins.fidget.enable = true;
  #   plugins.treesitter = {
  #     enable = true;
  #     grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
  #       json
  #         lua
  #         markdown
  #         nix
  #         regex
  #         toml
  #         xml
  #         yaml
  #         rust
  #         python
  #     ];
  #     lazyLoad.settings.event = "BufRead";
  #   };
  #   plugins.trouble = {
  #     enable = true;
  #     lazyLoad.settings.cmd = "Trouble";
  #   };
  #   plugins.lsp = {
  #     lazyLoad.settings.event = "BufRead";
  #     enable = true;
  #     inlayHints = true;
  #     servers = {
  #       rust_analyzer = {
  #         enable = true;
  #         package = null;
  #         installCargo = false;
  #         installRustc = false;
  #         installRustfmt = false;
  #       };
  #       nixd = {
  #         enable = true;
  #       };
  #     };
  #   };
  #   plugins.lspsaga = {
  #     enable = true;
  #   };
  #   plugins.yazi = {
  #     lazyLoad.settings.cmd = "Yazi";
  #     enable = true;
  #   };
  #   extraPlugins = with pkgs.vimPlugins; [
  #     lzn-auto-require
  #   ];
  # };
}
