{config, lib, pkgs, ...}: {
  programs.firefox = {
    enable = true;
    languagePacks = ["zh-CN"];
    preferences = {
      toolkit.legacyUserProfileCustomizations.stylesheets = true;
    };
  }
}
