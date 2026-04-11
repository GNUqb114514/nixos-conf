{ pkgs, inputs, ... }:
{
  fonts.packages = with pkgs; [
    nerd-fonts.ubuntu-mono
    inputs.packages.packages.${pkgs.system}.dream-han-sans
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
