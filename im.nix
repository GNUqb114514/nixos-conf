{ pkgs, ... }: {
  i18n.inputMethod.type = "fcitx5";
  
  i18n.inputMethod.enable = true;

  i18n.inputMethod.fcitx5 = {
    addons = with pkgs; [
      fcitx5-gtk
      fcitx5-chinese-addons
      fcitx5-rime
      fcitx5-lua
      libsForQt5.fcitx5-configtool
    ];
    waylandFrontend = true;
  };
}
