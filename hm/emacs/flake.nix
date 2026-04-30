{
  description = "My simple system configuration - Emacs configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    systems.url = "github:nix-systems/default";

    flake-parts.url = "github:hercules-ci/flake-parts";

    org-hold = {
      url = "github:GNUqb114514/org-hold";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      systems,
      flake-parts,
      org-hold,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { config, ... }@top:
      {
        imports = [ ];
        flake = {
          homeModules.default =
            {
              config,
              lib,
              pkgs,
              ...
            }:
            {
              options.user.emacs = with lib; {
                inputs = mkOption {
                  description = "Inputs of my emacs configuration flake.";
                  internal = true;
                  readOnly = true;
                };

                enable = mkEnableOption "Emacs";

                extraPackages = mkOption {
                  description = "Extra packages for Emacs";
                  type = with types; listOf hm.types.selectorFunction;
                };
              };

              imports = [
                ./basic.nix
                ./completion.nix
                ./lsp.nix
                ./operation.nix
                ./org.nix
                ./roam.nix
                ./speed.nix
              ];

              config = lib.mkIf config.user.emacs.enable {
                user.emacs.inputs = inputs;

                services.emacs = {
                  client.enable = true;
                  enable = true;
                  defaultEditor = true;
                };

                programs.emacs = {
                  enable = true;
                  package = pkgs.emacs-pgtk;
                  extraPackages =
                    epkgs:
                    (
                      with epkgs;
                      [
                        good-scroll
                      ]
                      ++ (lib.concatMap (x: x epkgs) config.user.emacs.extraPackages)
                    );
                  extraConfig = ''
                    (defun my-set-font (&optional frame)
                      "Set the current font."
                      (set-fontset-font (not frame) 'han (font-spec :family "Dream Han Sans CN") frame))
                    (add-hook 'after-make-frame-functions #'my-set-font) ; Set Chinese font

                    (setopt word-wrap-by-category t)
                    (setopt confirm-kill-emacs #'yes-or-no-p)
                    (setopt display-line-numbers-type 'relative)

                    (add-hook 'after-init-hook #'column-number-mode)
                    (add-hook 'after-init-hook #'global-display-line-numbers-mode)

                    (add-hook 'prog-mode-hook #'electric-pair-mode)
                    (add-hook 'prog-mode-hook #'show-paren-mode)
                    (add-hook 'prog-mode-hook #'hs-minor-mode)
                    (add-hook 'prog-mode-hook #'kill-ring-deindent-mode)

                    (setopt auto-revert-avoid-polling t)	; Might lead to correctness problem with remote filesystems
                    (setopt auto-revert-interval 5)
                    (add-hook 'after-init-hook #'global-auto-revert-mode)

                    (setopt make-backup-files nil)
                    (setopt auto-save-default nil)
                    (setopt byte-compile-auto-compile nil)
                    (setopt load-prefer-newer t)
                    (setopt create-lockfiles nil)
                    (setopt recentf-save-file nil)
                    (tool-bar-mode -1)
                    (scroll-bar-mode -1)
                    (setopt frame-resize-pixelwise t)

                    (use-package good-scroll
                      :if window-system
                      :hook (after-init . good-scroll-mode))

                    (add-hook 'rust-mode-hook
                              (lambda () (setq indent-tabs-mode nil)))

                    (setopt split-height-threshold 40)
                    (setopt split-width-threshold 100)

                  '';
                };
              };
            };
        };

        systems = import systems;
      }
    );
}
