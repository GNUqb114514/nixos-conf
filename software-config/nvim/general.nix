{ pkgs, ... }: {
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
    };

    visuals.fidget-nvim.enable = true;

    languages.markdown.extensions.markview-nvim = {
      enable = true;
      setupOpts = {
        list_items = {
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
