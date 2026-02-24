{
  pkgs,
  lib,
  config,
  ...
}@args:
let
  cfg = config.user.emacs;
  ulib = import ./lib.nix args;
  inputs = config.user.inputs;
in
{
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      (ulib.use-packages [
        {
          name = "rust-mode";
          initPhase = "(setopt rust-mode-treesitter-derive t)";
          configPhase = "(add-hook 'rust-mode-hook 'eglot-ensure)";
        }
        {
          name = "nix-mode";
          extraConfig = ''
            :mode "\\.nix\\'"
          '';
        }
      ])
      {
        user.emacs.extraPackages = [
          (
            epkgs:
            (with epkgs; [
              tree-sitter-langs
              (treesit-grammars.with-grammars (p: [
                p.tree-sitter-elisp
                p.tree-sitter-markdown
                p.tree-sitter-markdown-inline
                p.tree-sitter-nix
                p.tree-sitter-python
                p.tree-sitter-rust
                p.tree-sitter-toml
                p.tree-sitter-typst
                p.tree-sitter-yaml
              ]))
            ])
          )
        ];
      }
    ]
  );
}
