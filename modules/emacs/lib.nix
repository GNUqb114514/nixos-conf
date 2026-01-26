{ pkgs, lib, ... }: rec {
  use-package-bindSpec = {
    map ? null,
    ...
  }@args: '':bind (${if map != null then ":map ${map}" else "; Global Mapping"}
                   ${lib.concatMapAttrsStringSep "" (key: val:
                      if key == "map" then "" else
                      "(\"${key}\" . ${val})")
                    args})'';
  use-package = {
    name,
    package ? epkgs: epkgs."${name}",
    requirements ? [],

    demand ? false,
    condition ? "t",

    initPhase ? "()",
    prefacePhase ? "()",
    configPhase ? "()",

    bind ? [],
    custom ? {},

    extraConfig ? "",
  }: (lib.mkMerge [{
    user.emacs.extraPackages = [(epkgs: [
      (package epkgs)
    ])];
    programs.emacs.extraConfig = ''
(use-package ${name}
  :if ${condition}
  ${if builtins.length requirements != 0 then ":after (${lib.concatMapStringsSep " " (x: if builtins.isAttrs x then x.name else x) requirements})" else ""}
  :demand ${if demand then "nil" else "t"}
  :init ${initPhase}
  :preface ${prefacePhase}
  :config ${configPhase}
  ${if builtins.length (builtins.attrNames custom) != 0
    then ":custom ${lib.concatMapAttrsStringSep "" (name: value: "(${name} ${value})") custom}"
    else "; No custom"}
  ${lib.concatMapStrings use-package-bindSpec bind}
  ${extraConfig})
      '';
  } (use-packages requirements)]);

  use-packages = list: lib.mkMerge (map (pkg: if builtins.isAttrs pkg then use-package pkg else {}) list);
}
