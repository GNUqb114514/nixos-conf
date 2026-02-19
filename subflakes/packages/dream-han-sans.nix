{
  stdenvNoCC,
  fetchzip,
  fetchurl,
  lib,
  unzip,
}:
stdenvNoCC.mkDerivation {
  pname = "dream-han-sans";
  version = "3.02";

  src = fetchzip {
    url = "https://github.com/Pal3love/dream-han-cjk/releases/download/dream-3.02-sans-2.004-serif-2.003/DreamHanSansCN.zip";
    hash = "sha256-j90CySSC7c4jpwMqulA36oNv2/zZ5MgYCjZyfLB9i4I=";
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
