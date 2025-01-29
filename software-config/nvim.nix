{ config, pkgs, ... }: let
  helpers = config.lib.nixvim;
in {
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    opts = {
      relativenumber = true;
      number = true;
    };
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
    plugins.gitblame.enable = true;
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
