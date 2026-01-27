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
        emacs-application-framework
      ] ++ (lib.concatMap (x: x epkgs) cfg.extraPackages));
      extraConfig = ''
(use-package good-scroll
  :if window-system
  :config (good-scroll-mode))

(use-package eaf)

(use-package eaf-browser
  :requires eaf)
      '';
    };
  };
}
