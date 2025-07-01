{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.user.shell;
in {
  options.user.shell = with lib; {
    enable = mkEnableOption "shell";

    neogitAlias = mkEnableOption "shell alias for neogit";

    autosuggestion = mkEnableOption "autosuggestion";

    starship = mkEnableOption "starship";

    fzf = mkEnableOption "fzf";
    fzf-tab = mkEnableOption "fzf-tab";

    vi-mode = mkEnableOption "zsh-vi-mode";

    utilities = {
      archive = mkEnableOption "archive managers";

      monitors = mkEnableOption "sytem monitors";

      file-manager = mkEnableOption "file managers";

      pretty = mkEnableOption "pretty-printers";

      tui = mkEnableOption "TUI things";

      jq = mkEnableOption "jq";
      gh = mkEnableOption "gh";
    };
  };

  config = lib.mkIf cfg.enable {
    warnings = lib.optionals (cfg.utilities.tui && !config.user.terminal) ["TUI things require GUI features."];

    programs.zsh.enable = true;

    programs.zsh.plugins =
      lib.optionals cfg.vi-mode [
        {
          name = "zsh-vi-mode";
          src = pkgs.zsh-vi-mode;
          file = "share/zsh-vi-mode/zsh-vi-mode.plugin.zsh";
        }
      ]
      ++ lib.optionals cfg.fzf-tab [
        {
          name = "fzf-tab";
          src = pkgs.zsh-fzf-tab;
          file = "share/fzf-tab/fzf-tab.plugin.zsh";
        }
      ];

    programs.zsh.shellAliases = lib.mkIf cfg.neogitAlias {
      neogit = "nvim '+lua require(\"neogit\").open({kind=\"replace\"})' '+lua vim.api.nvim_buf_set_keymap(0, \"n\", \"q\", \"<cmd>q<cr>\", {})'";
    };

    programs.zsh.initContent = lib.mkMerge [
      (lib.mkIf cfg.fzf-tab ''
        zstyle ':completion:*:descriptions' format '[%d]'
        zstyle ':fzf-tab:*' switch-group '<' '>'
      '')
    ];

    programs.zsh.autosuggestion.enable = cfg.autosuggestion;

    programs.starship = {
      enable = cfg.starship;
      enableZshIntegration = cfg.starship;
    };

    programs.fzf = {
      enable = cfg.fzf;
      defaultOptions = [
        "--layout reverse"
      ];

      historyWidgetOptions = [
        "--layout reverse"
      ];
      enableZshIntegration = true;
    };

    home.packages = with lib; let
      util = cfg.utilities;
    in
      (with pkgs; [
        nh
        just
      ])
      ++ lib.optionals util.archive (with pkgs; [
        zip
        xz
        unzip
      ])
      ++ lib.optionals util.monitors (with pkgs; [
        iftop
        htop
        iotop
      ])
      ++ lib.optionals (util.monitors && config.user.terminal) [pkgs.btop]
      ++ lib.optionals util.file-manager (with pkgs; [
        file
        which
        tree
        ripgrep
      ])
      ++ lib.optionals util.pretty (with pkgs; [
        bat
        delta
      ])
      ++ lib.optionals (util.tui && config.user.terminal) (with pkgs; [
        fastfetch
        yazi
      ])
      ++ lib.optionals util.jq [pkgs.jq]
      ++ lib.optionals util.gh [pkgs.gh];
  };
}
