{
  pkgs,
  lib,
  config,
  ...
}: let cfg = config.user.emacs; in {
  imports = [
    ./basic.nix
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
        mwim
        good-scroll
        hydra
        use-package-hydra
        multiple-cursors
        rainbow-delimiters
        yasnippet
        yasnippet-capf
        cape
        corfu
        yasnippet-snippets
        consult
        emacs-application-framework
      ] ++ (lib.concatMap (x: x epkgs) cfg.extraPackages));
      extraConfig = ''
(use-package mwim
  :bind
  ("C-a" . mwim-beginning-of-code-or-line)
  ("C-e" . mwim-end-of-code-or-line))

(use-package good-scroll
  :if window-system
  :config (good-scroll-mode))

(use-package hydra)

(use-package use-package-hydra
  :after hydra)

(use-package multiple-cursors
  :after hydra
  :bind
  (("C-x C-h m" . hydra-multiple-cursors/body)
   ("C-S-<mouse-1>" . mc/toggle-cursor-on-click))
  :hydra
  (hydra-multiple-cursors
   (:hint nil)
   "
Up^^       Down^^      Miscellaneous      % 2(mc/num-cursors) cursor%s(if (> (mc/num-cursors) 1) \"s\" \"\")
------------------------------------------------------------------
 [_p_]  Prev   [_n_]  Next   [_l_] Edit lines [_0_] Insert numbers
 [_P_]  Skip   [_N_]  Skip   [_a_] Mark all  [_A_] Insert letters
 [_M-p_] Unmark  [_M-n_] Unmark  [_s_] Search   [_q_] Quit
 [_|_] Align with input CHAR    [Click] Cursor at point"
   ("l" mc/edit-lines :exit t)
   ("a" mc/mark-all-like-this :exit t)
   ("n" mc/mark-next-like-this)
   ("N" mc/skip-to-next-like-this)
   ("M-n" mc/unmark-next-like-this)
   ("p" mc/mark-previous-like-this)
   ("P" mc/skip-to-previous-like-this)
   ("M-p" mc/unmark-previous-like-this)
   ("|" mc/vertical-align)
   ("s" mc/mark-all-in-region-regexp :exit t)
   ("0" mc/insert-numbers :exit t)
   ("A" mc/insert-letters :exit t)
   ("<mouse-1>" mc/add-cursor-on-click)
   ("<down-mouse-1>" ignore)
   ("<drag-mouse-1>" ignore)
   ("q" nil)))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

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

(use-package consult
  :config
  (setq consult-fd-args "fd -H -u") ; 不忽视隐藏文件（Windows 用户请删除这一行）
  :bind
  ("C-x b" . consult-buffer)
  ("C-f" . consult-line)
  ("C-c f" . consult-fd) ; windows 用不了，删掉这行
  ("C-c r" . consult-ripgrep))

(use-package eaf)

(use-package eaf-browser
  :requires eaf)
      '';
    };
  };
}
