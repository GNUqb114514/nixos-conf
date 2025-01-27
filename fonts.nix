{lib, config, options, pkgs, ...}: {
  fonts.packages = with pkgs; [
    nerd-fonts.ubuntu
    nerd-fonts.ubuntu-mono
    source-han-sans
    source-han-serif
    # foundertypeFonts.fzktk
    # lxgw-wenkai
  ];

  fonts.fontconfig.defaultFonts = {
    sansSerif = ["Ubuntu Nerd Font"  "Source Han Sans SC"];
    serif = ["Source Han Serif SC"];
    monospace = ["UbuntuMono Nerd Font" "Source Han Sans SC"];
  };
}
