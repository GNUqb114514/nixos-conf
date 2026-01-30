{
  pkgs,
  lib,
  config,
  ...
}: let cfg = config.user.emacs; in {
  imports = [
    ./basic.nix
    ./operation.nix
    ./completion.nix
  ];

  options.user.emacs = with lib; {
    enable = mkEnableOption "emacs";

    extraPackages = mkOption {
      description = "Extra packages for Emacs";
      type = with types; listOf hm.types.selectorFunction;
    };
  };
  
  config = lib.mkIf cfg.enable {
    programs.emacs = {
      enable = true;
      package = pkgs.emacs-pgtk;
      extraPackages = epkgs: (with epkgs; [
        good-scroll
      ] ++ (lib.concatMap (x: x epkgs) cfg.extraPackages));
      extraConfig = ''
(setopt confirm-kill-emacs #'yes-or-no-p)
(electric-pair-mode t)
(add-hook 'prog-mode-hook #'show-paren-mode)
(column-number-mode t)
(global-auto-revert-mode t)
(setopt make-backup-files nil)
(setopt auto-save-default nil)
(setopt byte-compile-auto-compile nil)
(setopt load-prefer-newer t)
(setopt create-lockfiles nil)
(setopt recentf-save-file nil)
(setopt load-prefer-newer t)
(add-hook 'prog-mode-hook #'hs-minor-mode)
(global-display-line-numbers-mode 1)
(tool-bar-mode -1)
(when (display-graphic-p) (toggle-scroll-bar -1))
(setopt display-line-numbers-type 'relative)
(setopt frame-resize-pixelwise t)

(use-package good-scroll
  :if window-system
  :config (good-scroll-mode))
      '';
    };
  };
}
