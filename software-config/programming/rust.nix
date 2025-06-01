{ pkgs, ... }: {
  home.packages = with pkgs; [
    cargo
    rustc
    rustfmt
    clippy
  ];

  programs.nvf.settings.vim.languages.rust.enable = true;
}
