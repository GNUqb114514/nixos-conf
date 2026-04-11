{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.user.rime;
  inputs = config.user.inputs;

  rimeUserData = ".local/share/fcitx5/rime";

  rime = pkgs.fcitx5-rime.override {
    rimeDataPkgs = with pkgs; [
      (
        let
          generalPatch = writeText "rime-general-patch" ''
            patch:
              switches/+:
              engine/filters/+:
                - lua_filter@*cn_en_spacer
          '';
        in
        stdenvNoCC.mkDerivation rec {
          name = "rime-ice-patched";
          version = rime-ice.version;
          src = rime-ice.overrideAttrs (old: {
            patches = (old.patches or [ ]) ++ [ ./switchable-cn-en-spacer.patch ];
          });
          installPhase = ''
            cp . $out -r
            ls $out/share/rime-data/*.schema.yaml | sed 's/\.schema\./.custom./' | xargs -i sh -c 'cat < ${generalPatch} > {}'
          '';
        }
      )
      (writeTextFile {
        name = "rime-default-custom";
        text = ''
          patch:
            __include: rime_ice_suggestion:/
            menu/page_size: 9
            key_binder/bindings/+:
              - { when: paging, accept: comma, send: Page_Up }
              - { when: has_menu, accept: period, send: Page_Down }
        '';
        destination = "/share/rime-data/default.custom.yaml";
      })
    ];
  };
in
{
  options.user.rime = with lib; {
    enable = mkEnableOption "Rime";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ librime ]; # For helpers
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        addons = with pkgs; [
          rime
        ];
      };
    };

    home.file.${rimeUserData} = {
      source = "${rime}/share/rime-data";
      recursive = true;
    };

    home.activation = {
      redeployRime = lib.hm.dag.entryAfter [ "WriteBoundary" ] ''
        if [ -d ${rimeUserData} ] && [ "$(${pkgs.coreutils}/bin/stat -c %Y ${rimeUserData})" != "$(${pkgs.coreutils}/bin/stat -c %Y ${rimeUserData}/build)" ]; then
          # No redeployments required
          :
        else
          echo "Redeploying rime settings..."
          run ${pkgs.librime}/bin/rime_deployer --build ${rimeUserData} ${rimeUserData} ${rimeUserData}/build
        fi
      '';
    };

    i18n.inputMethod.fcitx5.settings =
      let
        fcitxStyleList =
          list:
          builtins.listToAttrs
            (builtins.foldl'
              (prev: value: {
                counter = prev.counter + 1;
                value = prev.value ++ [
                  {
                    name = toString prev.counter;
                    inherit value;
                  }
                ];
              })
              {
                counter = 0;
                value = [ ];
              }
              list
            ).value;
      in
      {
        globalOptions = {
          Hotkey = {
            EnumerateWithTriggerKeys = true;
            EnumerateSkipFirst = false;
          };

          "Hotkey/TriggerKeys" = fcitxStyleList [
          ];

          "Hotkey/AltTriggerKeys" = fcitxStyleList [
          ];

          "Hotkey/ActivateKeys" = fcitxStyleList [
          ];

          "Hotkey/DeactivateKeys" = fcitxStyleList [
          ];

          Behavior = {
            ActiveByDefault = "True";
            resetStateWhenFocusIn = "No";
            ShareInputState = "No";
            PreeditEnabledByDefault = "True";
            ShowInputMethodInformation = "True";
            showInputMethodInformationWhenFocusIn = "False";
            CompactInputMethodInformation = "True";
            ShowFirstInputMethodInformation = "True";
            PreloadInputMethod = "True";
          };
        };
        inputMethod = {
          GroupOrder."0" = "默认";
          "Groups/0" = {
            Name = "默认";
            "Default Layout" = "us";
            DefaultIM = "rime";
          };
          "Groups/0/Items/0" = {
            Name = "keyboard-us";
            Layout = "";
          };
          "Groups/0/Items/1" = {
            Name = "rime";
            Layout = "";
          };
        };
      };
  };
}
