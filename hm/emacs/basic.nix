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
    ulib.usePackages [
      {
        name = "vertico";
        requirements = [ "orderless" ];
        extraConfig = ''
          :hook (after-init . vertico-mode)
        '';
      }
      {
        name = "orderless";
        custom = {
          completion-styles = "'(orderless)";
          orderless-component-separator = ''"[ -]"'';
        };
      }
      {
        name = "marginalia";
        requirements = [ "vertico" ];
        extraConfig = ''
          :hook (after-init . marginalia-mode)
        '';
        configPhase = ''
          (mapc (lambda (x)
                  (setcdr x (remq 'builtin (cdr x))))
                marginalia-annotators)
        '';
        bind = [
          {
            map = "minibuffer-local-map";
            "M-A" = "marginalia-cycle";
          }
        ];
      }
      # {
      #   name = "diminish";
      #   demand = true;
      #   configPhase = "(diminish 'hs-minor-mode)";
      # }
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
    ]
  );
}
