{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    nerd-fonts.ubuntu-mono
    (import ./subflakes/packages/default.nix { inherit pkgs; }).dream-han-sans
    source-han-serif
  ];

  fonts.fontconfig.defaultFonts = {
    sansSerif = [
      "Ubuntu Nerd Font"
      "Dream Han Sans CN"
    ];
    serif = [ "Source Han Serif SC" ];
    monospace = [
      "Maple Mono NF"
      "UbuntuMono Nerd Font"
      "Dream Han Sans CN"
    ];
  };
}
