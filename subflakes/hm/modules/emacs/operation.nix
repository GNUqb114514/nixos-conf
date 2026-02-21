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
        name = "mwim";
        bind = [
          {
            "C-a" = "mwim-beginning-of-code-or-line";
            "C-e" = "mwim-end-of-code-or-line";
          }
        ];
      }
      {
        name = "use-package-hydra";
        requirements = [
          { name = "hydra"; }
        ];
      }
      {
        name = "multiple-cursors";
        requirements = [ "hydra" ];
        bind = [
          {
            "C-x C-h m" = "hydra-multiple-cursors/body";
          }
        ];
        extraConfig = ''
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
             ("q" nil))
        '';
      }
      {
        name = "consult";
        custom = {
          consult-fd-args = "\"fd -H -u\"";
        };
        bind = [
          {
            "C-x b" = "consult-buffer";
            "C-f" = "consult-line";
            "C-c f" = "consult-fd";
            "C-c r" = "consult-ripgrep";
          }
        ];
      }
    ]
  );
}
