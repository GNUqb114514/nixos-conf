{ pkgs, ... }: {
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
  in [
    (nrml-plugin "jeffreytse" "zsh-vi-mode" "cd730cd347dcc0d8ce1697f67714a90f07da26ed" "sha256-EWMeslDgs/DWVaDdI9oAS46hfZtp4LHTRY8TclKTNK8=")
    (nrml-plugin "Aloxaf" "fzf-tab" "6aced3f35def61c5edf9d790e945e8bb4fe7b305" "sha256-EWMeslDgs/DWVaDdI9oAS46hfZtp4LHTRY8TclKTNK8=")
  ];

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
