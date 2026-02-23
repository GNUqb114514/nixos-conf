{ pkgs, ... }:
rec {
  foundrytools = pkgs.python3.pkgs.callPackage ./foundrytools.nix { };
  foundrytools-cli = pkgs.python3.pkgs.callPackage ./foundrytools-cli.nix {
    inherit foundrytools;
  };
  maple-font-custom-build = pkgs.callPackage ./maple-font-custom-build.nix {
    inherit foundrytools-cli;
    fontConfig = {
      feature_freeze = {
        cv01 = "enable";
        cv02 = "enable";
        cv03 = "enable";
        cv62 = "enable";
        ss01 = "enable";
        ss02 = "enable";
        ss06 = "enable";
        ss07 = "enable";
        zero = "enable";
      };
      nerd_font = {
        enable = true;
        mono = false;
        propo = false;
      };
      cn = {
        enable = false;
      };
    };
  };
  dream-han-sans = pkgs.callPackage ./dream-han-sans.nix { };
}
