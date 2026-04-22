{
  pkgs,
  inputs,
  ...
}:
{
  home.packages = [ pkgs.wget ];

  home.username = "qb114514";
  home.homeDirectory = "/home/qb114514";

  programs.nh.enable = true;
  programs.nh.flake = "/home/qb114514/nixos-conf";
  programs.nh.clean.enable = true;
  programs.nh.clean.dates = "weekly";

  programs.git = {
    enable = true;
    settings.user.name = "qb114514";
    settings.user.email = "GNUqb114514@outlook.com";
  };

  programs.lazygit = {
    enable = true;
  };

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  programs.firefox.enable = true;

  programs.firefox.languagePacks = [
    "en-US"
    "zh-CN"
  ];

  programs.firefox.profiles = {
    default = {
      id = 0;
      name = "default";
      isDefault = true;
      bookmarks = {
        force = true;
        settings = import ./software-config/firefox/bookmarks.nix;
      };
      settings = {
        "extensions.autoDisableScopes" = 0;
        "browser.display.use_document_fonts" = 0;
        "browser.startup.page" = 3;
        "general.useragent.locale" = "zh-CN";
      };
      userContent = builtins.readFile ./software-config/firefox/userChrome.css;
      search.force = true;
      search.default = "bing";
      search.engines = import ./software-config/firefox/search-engines.nix pkgs;
    };
  };

  imports = [
    inputs.hm.homeModules.qb
  ];

  user = {
    ssh.enable = true;
    stylix = {
      enable = true;
      colorscheme = "catppuccin-latte";
      polarity = "light";
    };
    rime = {
      enable = true;
    };
    shell = {
      enable = true;
      neogitAlias = true;
      autosuggestion = true;
      starship = true;
      fzf = true;
      fzf-tab = true;
      vi-mode = true;
      utilities = {
        archive = true;
        monitors = true;
        file-manager = true;
        pretty = true;
        tui = true;
        jq = true;
        gh = true;
      };
    };
    programming = {
      python = true;
      rust = true;
      cpp = true;
      lua = true;
      markdown = true;
      nix = true;
      typst = true;
      bluespec = true;
    };
    terminal = true;
    gui = {
      enable = true;
    };

    nvim = {
      enable = true;
      exrc = true;
      yazi = true;
      window-picker = true;
      flash = true;
      surround = true;
      telescope = true;
      lsp = {
        enable = true;
        saga = true;
      };
      extraProgrammingSupport = true;
      trouble = true;
      neogit = true;
      completion = {
        enable = true;
        snippets = true;
        lazydev = true;
      };
      fold = true;
      oil = true;
    };
    helix = {
      enable = true;
      custom-theming = true;
    };

    qutebrowser = {
      enable = true;
      disable-gpu = true;
    };

    xremap = {
      enable = true;
      capslock-as-esc = true;
      home-row-numbers = true;
      home-row-modifiers = true;
      space-as-shift = true;
    };

    waybar = {
      enable = true;
      customCss = true;
    };

    emacs = {
      enable = true;
      # neomacs = true;
    };

    idle.enable = true;

    bluetooth.enable = true;

    direnv.enable = true;
  };
}
