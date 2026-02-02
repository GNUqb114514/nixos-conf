{
  pkgs,
  inputs,
  ...
}: {
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

  programs.firefox.languagePacks = [ "en-US" "zh-CN" ];

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
    inputs.niri-flake.homeModules.stylix
    inputs.niri-flake.homeModules.niri
    inputs.nvf.homeManagerModules.default
    inputs.stylix.homeModules.stylix
    inputs.xremap.homeManagerModules.default
    # ./colorschemes/catppuccin-mocha.nix
    ./modules
    # ./modules/colorscheme.nix
  ];

  user = {
    ssh.enable = true;
    stylix = {
      enable = true;
      colorscheme = "catppuccin-mocha";
    };
    fcitx = {
      enable = true;
      settings = let
        fcitxStyleList = list:
          builtins.listToAttrs
          (
            builtins.foldl'
            (prev: value: {
              counter = prev.counter + 1;
              value =
                prev.value
                ++ [
                  {
                    name = toString prev.counter;
                    inherit value;
                  }
                ];
            })
            {
              counter = 0;
              value = [];
            }
            list
          ).value;
      in {
        globalOptions = {
          Hotkey = {
            EnumerateWithTriggerKeys = true;
            EnumerateSkipFirst = false;
          };

          "Hotkey/TriggerKeys" = fcitxStyleList ["Shift+Shift_L" "Shift+Shift_R"];
          "Hotkey/EnumerateForwardKeys" = fcitxStyleList ["Super+space"];
          "Hotkey/EnumerateBackwardKeys" = fcitxStyleList ["Shift+Super+space"];
          "Hotkey/PrevPage" = fcitxStyleList ["comma" "Page_up" "Up"];
          "Hotkey/NextPage" = fcitxStyleList ["period" "Next" "Down"];
          "Hotkey/PrevCandidate" = fcitxStyleList ["Shift+Tab"];
          "Hotkey/NextCandidate" = fcitxStyleList ["Tab"];

          Behavior = {
            ActiveByDefault = false;
            resetStateWhenFocusIn = "No";
            ShareInputState = "No";
            PreeditEnabledByDefault = true;
            ShowInputMethodInformation = true;
            showInputMethodInformationWhenFocusIn = false;
            CompactInputMethodInformation = true;
            ShowFirstInputMethodInformation = true;
            DefaultPageSize = 9;
            PreloadInputMethod = true;
          };
        };
        inputMethod = {
          GroupOrder."0" = "默认";
          "Groups/0" = {
            Name = "默认";
            "Default Layout" = "us";
            DefaultIM = "shuangpin";
          };
          "Groups/0/Items/0" = {
            Name = "keyboard-us";
            Layout = "";
          };
          "Groups/0/Items/1" = {
            Name = "shuangpin";
            Layout = "";
          };
          "Groups/0/Items/2" = {
            Name = "pinyin";
            Layout = "";
          };
        };
        addons.pinyin = {
          globalSection = {
            ShuangpinProfile = "Xiaohe";
            ShowShuangpinMode = true;
            PageSize = 9;
            SpellEnabled = true;
            SymbolsEnabled = true;
            ChaiziEnabled = true;
            ExtBEnabled = true;
            CloudPinyinEnabled = true;
            CloudPinyinIndex = 2;
            CloudPinyinAnimation = true;
            KeepCloudPinyinPlaceholder = false;
            PreeditMode = "Composing pinyin";
            PreeditCursorPositionAtBeginning = false;
            SwitchInputMethodBehavior = "Commit current preedit";
            UseKeypadAsSelection = true;
            QuickPhraseKey = "grave";
            VAsQuickphrase = true;
          };
          sections = {
            PrevPage = fcitxStyleList ["comma" "Page_up" "Up"];
            NextPage = fcitxStyleList ["period" "Next" "Down"];
            PrevCandidate = fcitxStyleList ["Shift+Tab"];
            NextCandidate = fcitxStyleList ["Tab"];
            CurrentCandidate = fcitxStyleList ["space" "KP_space"];
            CommitRawInput = fcitxStyleList ["Return" "KP_Enter"];
            ChooseCharFromPhrase = fcitxStyleList ["bracketleft" "bracketright"];
            FilterByStroke = fcitxStyleList ["Shift+grave"];
            QuickPhraseTriggerRegex = fcitxStyleList [".(/|@)$" ''^(www|bbs|forum|mail|bbs)\\.'' "^(http|https|ftp|telnet|mailto):"];
          };
        };
      };
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
      mpv = true;
      swaync = true;
      swayosd = true;
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
      custom-css = true;
    };

    emacs = {
      enable = true;
    };
  };
}
