{
  config,
  lib,
  ...
}:
let
  cfg = config.user.xremap;
in
{
  options.user.xremap = with lib; {
    enable = mkEnableOption "xremap";
    capslock-as-esc = mkEnableOption "capslock-as-esc";
    home-row-numbers = mkEnableOption "home row numbers";
    home-row-modifiers = mkEnableOption "home row modifiers";
  };

  config = lib.mkIf cfg.enable ({
    services.xremap.enable = true;
    services.xremap.config =
      let
        hold-alone = held: alone: { inherit held alone; freehold = true; };
        hold-alone-same = builtins.mapAttrs (name: value: hold-alone value name);
      in
      lib.mkMerge [
        (lib.mkIf cfg.capslock-as-esc {
          keymap = [
            {
              name = "CapsLock as Esc";
              exact_match = true;
              remap = {
                "CapsLock" = "Esc";
              };
            }
          ];
        })
        (lib.mkIf cfg.home-row-numbers {
          keymap = [
            {
              name = "Home Row Numbers";
              remap = lib.attrsets.mapAttrs' (name: value: lib.nameValuePair "Alt_R-${name}" value) {
                a = "1";
                s = "2";
                d = "3";
                f = "4";
                g = "5";
                h = "6";
                j = "7";
                k = "8";
                l = "9";
                semicolon = "0";
              };
            }
          ];
        })
        (lib.mkIf cfg.home-row-modifiers {
          modmap = [
            {
              name = "Home Row Modifiers";
              remap = hold-alone-same {
                f = "LeftMeta";
                j = "RightMeta";
                d = "LeftCtrl";
                k = "RightCtrl";
              };
            }
          ];
        })
      ];
  });
}
