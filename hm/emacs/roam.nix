# -*- separedit-default-mode: emacs-lisp-mode; -*-
{pkgs, lib, config, ...}@args:
let cfg = config.user.emacs; ulib = import ./lib.nix args; inputs = config.user.emacs.inputs; in
{
  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      (ulib.usePackages [
        {
          name = "org-roam";
          custom = {
            org-roam-directory = ''(file-truename "~/org/zettelkasten")'';

          };
          bind = [{
            "C-c n l" = "#'org-roam-buffer-toggle";
            "C-c n f" = "#'org-roam-node-find";
            "C-c n i" = "#'org-roam-node-insert";
          }];
          configPhase = ''(org-roam-setup)'';
        }
      ])
    ]
  );
}
