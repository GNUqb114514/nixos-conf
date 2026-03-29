{
  stdenvNoCC,
  fetchzip,
  fetchurl,
  lib,
  unzip,
}:
stdenvNoCC.mkDerivation {
  pname = "dream-han-sans";
  version = "3.03";

  src = fetchzip {
    url = "https://github.com/Pal3love/dream-han-cjk/releases/download/dream-3.03-sans-2.005-serif-2.003/DreamHanSansCN.zip";
    hash = "sha256-nU5byB67+CVbUDt93GEIZEqYFPkKWG2e9+um7e8UZ4Q=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';

  meta = {
    description = "Open-source pan-CJK font families with enormous range of weights, the CJK sans and serif you have dreamed of.";
    homepage = "https://github.com/Pal3love/dream-han-cjk";
    license = lib.licenses.ofl;
  };
}
