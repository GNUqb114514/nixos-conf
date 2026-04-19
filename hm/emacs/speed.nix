# -*- separedit-default-mode: emacs-lisp-mode; -*-
{ pkgs, lib, config, ... }@args: let cfg = config.user.emacs; in {
  config = lib.mkIf cfg.enable (
    lib.mkMerge [{
      programs.emacs.extraConfig = lib.mkBefore ''
        (setopt gc-cons-threshold (* 512 1024 1024))
        (add-hook 'emacs-startup-hook
                  (lambda () (setopt gc-cons-threshold (* 1000 1000))))
      '';
    }]
  );
}
