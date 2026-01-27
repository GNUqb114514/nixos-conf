{
  pkgs,
  lib,
  config,
  ...
}: let cfg = config.user.emacs; in {
  imports = [
    ./basic.nix
    ./operation.nix
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
        yasnippet
        yasnippet-capf
        cape
        corfu
        yasnippet-snippets
        emacs-application-framework
      ] ++ (lib.concatMap (x: x epkgs) cfg.extraPackages));
      extraConfig = ''
(use-package good-scroll
  :if window-system
  :config (good-scroll-mode))

(use-package yasnippet
  :diminish yas-minor-mode
  :demand t
  :preface
  (setq 
   yas-cache-directory (expand-file-name "emacs/yasnippet/" (or (getenv "XDG_CACHE_HOME") "~/.cache"))
   yas-snippet-dirs (list (expand-file-name "emacs/yasnippet/snippets/" (or (getenv "XDG_DATA_HOME") "~/.local/share"))))
  :config
  (yas-reload-all)
  (yas-minor-mode t)
  (define-key yas-minor-mode-map [(tab)]    nil)
  (define-key yas-minor-mode-map (kbd "TAB")  nil)
  (define-key yas-minor-mode-map (kbd "<tab>") nil)
  :custom
  (completion-at-point-functions (cons #'yas-completion-at-point))
  :bind
  (:map yas-minor-mode-map ("S-<tab>" . yas-expand)))

(use-package yasnippet-capf
  :after yasnippet
  :requires yasnippet
  :custom
  (yasnippet-capf-lookup-by 'name)
  :config
  (add-to-list 'completion-at-point-functions #'yasnippet-capf))

(use-package cape
  :demand t
  :after yasnippet-capf
  :requires yasnippet
  :config
  (add-hook 'emacs-lisp-mode-hook
            (lambda () (setq-local completion-at-point-functions
                                   (list
                                    (cape-capf-super #'yasnippet-capf #'cape-elisp-symbol)
                                    #'cape-file)))))

(use-package corfu
  :demand t
  :after cape
  :config
  (global-corfu-mode)
  (require 'corfu-popupinfo)
  (corfu-popupinfo-mode t)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.1)
  (corfu-auto-trigger ".")
  (corfu-popupinfo-delay 0.1))

(use-package yasnippet-snippets
  :requires yasnippet
  :after yasnippet)

(use-package eaf)

(use-package eaf-browser
  :requires eaf)
      '';
    };
  };
}
