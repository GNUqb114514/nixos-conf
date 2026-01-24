{
  pkgs,
  lib,
  config,
  ...
}: let cfg = config.user.emacs; in {
  options.user.emacs = with lib; {
    enable = mkEnableOption "emacs";
  };
  
  config = lib.mkIf cfg.enable {
    programs.emacs = {
      enable = true;
      package = pkgs.emacs-pgtk;
      extraPackages = epkgs: with epkgs; [
        vertico
        orderless
        mwim
        good-scroll
        marginalia
        hydra
        multiple-cursors
        rainbow-delimiters
        yasnippet
        yasnippet-capf
        cape
        corfu
        yasnippet-snippets
        diminish
        consult
        emacs-application-framework
      ];
    };
  };
}
