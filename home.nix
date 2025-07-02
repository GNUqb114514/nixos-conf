{
  pkgs,
  inputs,
  ...
}: {
  home.username = "qb114514";
  home.homeDirectory = "/home/qb114514";

  programs.git = {
    enable = true;
    userName = "qb114514";
    userEmail = "GNUqb114514@outlook.com";
  };

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  imports = [
    inputs.niri-flake.homeModules.stylix
    inputs.niri-flake.homeModules.niri
    inputs.nvf.homeManagerModules.default
    inputs.stylix.homeModules.stylix
    ./software-config
    # ./colorschemes/catppuccin-mocha.nix
    ./modules
    # ./modules/colorscheme.nix
  ];

  user = {
    stylix = {
      enable = true;
      colorscheme = "catppuccin-mocha";
    };
    fcitx = {
      enable = true;
      addons = with pkgs; [
        fcitx5-gtk
        fcitx5-chinese-addons
        fcitx5-rime
        fcitx5-lua
        libsForQt5.fcitx5-configtool
      ];
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
                    name = builtins.toString prev.counter;
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
          "Hotkey/EnumerateForwardKeys" = fcitxStyleList ["Control+Tab" "Super+space"];
          "Hotkey/EnumerateBackwardKeys" = fcitxStyleList ["Control+Shift+Tab" "Shift+Super+space"];
          "Hotkey/PrevPage" = fcitxStyleList ["comma" "Page_up" "Up"];
          "Hotkey/NextPage" = fcitxStyleList ["period" "Next" "Down"];
          "Hotkey/PrevCandidate" = fcitxStyleList ["Left"];
          "Hotkey/NextCandidate" = fcitxStyleList ["Right"];

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
            PrevCandidate = fcitxStyleList ["Left"];
            NextCandidate = fcitxStyleList ["Right"];
            CurrentCandidate = fcitxStyleList ["space" "KP_space"];
            CommitRawInput = fcitxStyleList ["Return" "KP_Enter"];
            ChooseCharFromPhrase = fcitxStyleList ["bracketleft" "bracketright"];
            FilterByStroke = fcitxStyleList ["Tab"];
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
    programming = {rust = true;};
    terminal = true;
    gui = {
      enable = true;
      mpv = true;
      swaync = true;
    };
  };
}
