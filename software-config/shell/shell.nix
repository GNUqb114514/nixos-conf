{ lib, pkgs, ... }: {
  programs.zsh.enable = true;

  programs.zsh.plugins = let
    weird-plugin = name: owner: repo: rev: sha256: file: {
      inherit name file;
      src = pkgs.fetchFromGitHub {
        inherit owner repo rev sha256;
      };
    };
    gh-plugin = owner: repo: rev: sha256: name: {
      inherit name;
      src = pkgs.fetchFromGitHub {
        inherit owner repo rev sha256;
      };
    };
    nrml-plugin = owner: repo: rev: sha256: gh-plugin owner repo rev sha256 repo;
    users-plugin = name: rev: sha256: gh-plugin "zsh-users" "zsh-${name}" rev sha256 "zsh-${name}";
  in [
    # (nrml-plugin "jeffreytse" "zsh-vi-mode" "cd730cd347dcc0d8ce1697f67714a90f07da26ed" "sha256-EWMeslDgs/DWVaDdI9oAS46hfZtp4LHTRY8TclKTNK8=")
    # (nrml-plugin "Aloxaf" "fzf-tab" "6aced3f35def61c5edf9d790e945e8bb4fe7b305" "sha256-EWMeslDgs/DWVaDdI9oAS46hfZtp4LHTRY8TclKTNK8=")
    (nrml-plugin "olets" "zsh-autosuggestions-abbreviations-strategy" "8edbd1d52445d87172d355f8242082b1ec6c34e7" "sha256-hYl9zplPpMoCsGmxX+NQtECZ5dHgQYqZfTGdV0vcZPk=")
  ];

  programs.zsh.initExtraFirst = ''
    ABBR_SET_EXPANSION_CURSOR=1
    ABBR_SET_LINE_CURSOR=1
  '';

  programs.zsh.zsh-abbr.enable = true;
  programs.zsh.zsh-abbr.abbreviations = {
    rebuild = "nh os % .";
    neogit = "nvim '+lua require(\"neogit\").open({kind=\"replace\"})' '+lua vim.api.nvim_buf_set_keymap(0, \"n\", \"q\", \"<cmd>q<cr>\", {})'";
  };
  programs.zsh.autosuggestion.enable = true;

  # programs.zsh.autosuggestion.strategy = lib.mkBefore [ "abbreviations" ];
  programs.zsh.autosuggestion.strategy = lib.mkForce [];
  programs.zsh.localVariables = {
    ZSH_AUTOSUGGEST_STRATEGY = [ "abbreviations" "match_prev_cmd" "history" "completion" ];
  };

  programs.starship.enable = true;
  programs.starship.enableZshIntegration = true;

  programs.fzf.enable = true;

  programs.fzf.defaultOptions = [
    "--layout reverse"
  ];

  programs.fzf.historyWidgetOptions = [
    "--layout reverse"
  ];
}
