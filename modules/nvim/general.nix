{ pkgs, inputs, ... }: {
  # Add clipboard provider
  home.packages = with pkgs; [ wl-clipboard ];

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  programs.nvf.settings.vim = {
    globals.mapleader = " ";

    # Automatic shiftwidth changing
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

    languages.markdown.extensions.markview-nvim = {
      enable = true;
      setupOpts = {
        markdown.list_items = {
          marker_minus.text = "•";
          marker_plus.text = "⬥";
          marker_star.text = "⬦";
        };
      };
    };

    keymaps = [
      {
        key = "<leader>nh";
        mode = "n";
        action = "<cmd>nohlsearch<CR>";
      }
    ];
  };
}
