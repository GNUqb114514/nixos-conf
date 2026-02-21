{
  pkgs,
  lib,
  config,
  ...
}@args:
let
  cfg = config.user.emacs;
  ulib = import ./lib.nix args;
in
{
  config = lib.mkIf cfg.enable (
    ulib.use-packages [
      {
        name = "yasnippet";
        diminish = "yas-minor-mode";
        demand = true;
        configPhase = ''
          (yas-reload-all)
          (yas-global-mode)
        '';
      }
      {
        name = "yasnippet-snippets";
        requirements = [ "yasnippet" ];
      }
      {
        name = "yasnippet-capf";
        requirements = [ "yasnippet" ];
        custom = {
          yasnippet-capf-lookup-by = "'name";
        };
        configPhase = "(add-to-list 'completion-at-point-functions #'yasnippet-capf)";
      }
      {
        name = "cape";
        demand = true;
        requirements = [
          "yasnippet"
          "yasnippet-capf"
        ];
        configPhase = ''
          (add-hook 'emacs-lisp-mode-hook
                    (lambda ()
                      (yas-minor-mode)
                      (setq-local completion-at-point-functions
                                  (list
                                   (cape-capf-super #'yasnippet-capf #'cape-elisp-symbol)
                                   #'cape-file))))
        '';
      }
      {
        name = "corfu";
        demand = true;
        requirements = [ "cape" ];
        configPhase = "(global-corfu-mode)";
        custom = {
          corfu-auto = "t";
          corfu-auto-delay = "0.1";
          corfu-auto-trigger = "\".\"";
          corfu-popupinfo-delay = "0.1";
        };
      }
      {
        name = "corfu-popupinfo";
        package = null;
        requirements = [ "corfu" ];
        configPhase = "(corfu-popupinfo-mode t)";
      }
    ]
  );
}
