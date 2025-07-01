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
  };

  config = lib.mkIf cfg.enable {
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
  };
}
