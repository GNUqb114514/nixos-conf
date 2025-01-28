{ pkgs, ... }: {
  programs.fish.enable = true;

  programs.fish.shellAbbrs = {
    rebuild = "sudo nixos-rebuild switch --option substituters https://mirrors.ustc.edu.cn/nix-channels/store";
  };

  programs.fish.shellInitLast = ''
  set FZF_COMPLETE 3
  '';
}
