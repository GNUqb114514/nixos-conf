{
  stdenv,
  fetchFromGitHub,
  writeText,
  python3,
  foundrytools-cli,
  uv,
  debug ? false,
  fontConfig ? { },
}@deps:
with deps;
let
  configFile = config: writeText "config.json" (builtins.toJSON config);
in
stdenv.mkDerivation rec {
  pname = "maple-mono";
  version = "7.9";

  fontConfigPkg = configFile fontConfig;

  src = fetchFromGitHub {
    owner = "subframe7536";
    repo = "maple-font";
    rev = "v${version}";
    hash = "sha256-wsaE54TeI2EI9VO9Q7Czv9soScGomYIfrllhQQHey2E=";
  };

  nativeBuildInputs = [
    python3
    foundrytools-cli
    uv
  ]
  ++ (with python3.pkgs; [
    fonttools
    ttfautohint-py
    glyphslib
  ]);

  configurePhase = ''
    ln -sf ${fontConfigPkg} ./config.json
  '';

  buildPhase = ''
    ${if debug then "python3 ./build.py --dry" else ""}
    python3 ./build.py --ttf-only
  '';

  installPhase = ''
    install -D -m 644 fonts/{NF,TTF-AutoHint,Variable}/* -t $out/share/fonts/truetype
  '';
}
