{
  pkgs,
  lib,
  config,
  ...
}@args: let cfg = config.user.emacs; ulib = import ./lib.nix args; in {
  config = lib.mkIf cfg.enable (ulib.use-packages [
    {
      name = "vertico";
      configPhase = "(vertico-mode t)";
    }
    {
      name = "orderless";
      custom = {
        completion-styles = "'(orderless)";
      };
    }
    {
      name = "marginalia";
      demand = true;
      requirements = [ "vertico" ];
      configPhase = ''
        (mapc (lambda (x)
                (setcdr x (remq 'builtin (cdr x))))
              marginalia-annotators)
        (marginalia-mode t)
      '';
      extraConfig = ''
        :bind (:map minibuffer-local-map
               ("M-A" . marginalia-cycle))
      '';
    }
    {
      name = "diminish";
      configPhase = "(diminish 'hs-minor-mode)";
    }
    {
      name = "helpful";
      bind = [
        {
          "C-h f" = "#'helpful-callable";
          "C-h v" = "#'helpful-variable";
          "C-h k" = "#'helpful-key";
          "C-h x" = "#'helpful-command";
          "C-h C-h" = "#'helpful-at-point";
        }
      ];
    }
  ]);
}
