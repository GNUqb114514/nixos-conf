{ pkgs, ... }: {
  fonts.packages = with pkgs; [
    nerd-fonts.ubuntu-mono
    (pkgs.stdenv.mkDerivation {
  pname = "dream-han";
  version = "2.003";

  src = ./DreamHanSansCN.zip;

  unpackPhase = ''
    runHook preUnpack
    ${unzip}/bin/unzip $src

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 *.ttf -t $out/share/fonts/truetype

    runHook postInstall
  '';
    })
    source-han-serif
  ];

  fonts.fontconfig.defaultFonts = {
    sansSerif = ["Ubuntu Nerd Font"  "Source Han Sans SC"];
    serif = ["Source Han Serif SC"];
    monospace = ["Maple Mono" "UbuntuMono Nerd Font" "Source Han Sans SC"];
  };
}
