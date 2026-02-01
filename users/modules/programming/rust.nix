{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.user.programming.rust;
in {
  options.user.programming.rust = lib.mkEnableOption "Rust programming environment";

  config = lib.mkIf cfg {
    home.packages = [
      (
        let
          packages = with pkgs; [
            (rust-bin.stable.latest.default.override {
              extensions = [ "rust-analyzer" "rust-std" ];
            })
          ];
        in
        pkgs.runCommand "env-rust"
          {
            buildinputs = packages;
            nativeBuildInputs = [ pkgs.makeWrapper ];
          }
          ''
            mkdir -p $out/bin/
            ln -s ${pkgs.zsh}/bin/zsh $out/bin/env-rust
            wrapProgram $out/bin/env-rust --prefix PATH : ${pkgs.lib.makeBinPath packages}
          ''
      )
    ];

    programs.nvf.settings.vim.languages.rust.enable = true;
  };
}
