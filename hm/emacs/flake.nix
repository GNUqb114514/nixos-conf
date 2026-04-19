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
              ];

              config = lib.mkIf config.user.emacs.enable {
                user.emacs.inputs = inputs;

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
                    (set-fontset-font t 'han (font-spec :family "Dream Han Sans CN"))
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

                    (add-hook 'rust-mode-hook
                              (lambda () (setq indent-tabs-mode nil)))
                  '';
                };
              };
            };
        };

        systems = import systems;
      }
    );
}
