{ pkgs, lib, ... }:
let
  usePackageBindSpec =
    {
      map ? null,
      ...
    }@args:
    ''
      :bind (${if map != null then ":map ${map}" else "; Global Mapping"}
             ${lib.concatMapAttrsStringSep "" (key: val: if key == "map" then "" else "(\"${key}\" . ${val})") args})
    '';
  usePackage =
    {
      name,
      package ? epkgs: epkgs."${name}",
      requirements ? [ ],

      demand ? false,
      defer ? false,
      condition ? null,

      initPhase ? null,
      prefacePhase ? null,
      configPhase ? null,

      bind ? [ ],
      custom ? { },
      diminish ? null,

      extraConfig ? "",
    }:
    (lib.mkMerge [
      {
        user.emacs.extraPackages = lib.mkIf (package != null) [
          (epkgs: [
            (package epkgs)
          ])
        ];
        programs.emacs.extraConfig = ''
          (use-package ${name}
            ${if condition != null then ":if ${condition}" else "; Always load"}
            ${
              if builtins.length requirements != 0 then
                ":after (${lib.concatMapStringsSep " " (x: if builtins.isAttrs x then x.name else x) requirements})"
              else
                "; No requirements"
            }
            ${if demand then ":demand t" else "; No demad"}
            ${if defer then ":defer t" else "; No defer"}
            ${if initPhase != null then ":init ${initPhase}" else "; No init"}
            ${if prefacePhase != null then ":preface ${prefacePhase}" else "; No preface"}
            ${if configPhase != null then ":config ${configPhase}" else "; No config"}
            ${
              if builtins.length (builtins.attrNames custom) != 0 then
                ":custom ${lib.concatMapAttrsStringSep "" (name: value: "(${name} ${value})") custom}"
              else
                "; No custom"
            }
            ${lib.concatMapStrings usePackageBindSpec bind}
            ${if diminish != null then ":diminish ${diminish}" else "; No diminish"}
            ${extraConfig})
        '';
      }
      (usePackages requirements)
    ]);

  usePackages =
    list: lib.mkMerge (map (pkg: if builtins.isAttrs pkg then usePackage pkg else { }) list);
in
{
  inherit usePackage usePackages;
}
