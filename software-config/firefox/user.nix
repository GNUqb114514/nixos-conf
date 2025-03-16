{ pkgs, ... }: {
  programs.firefox.enable = true;

  programs.firefox.languagePacks = [ "en-US" "zh_CN" ];

  programs.firefox.profiles = {
    default = {
      id = 0;
      name = "default";
      isDefault = true;
      bookmarks = import ./bookmarks.nix;
      settings = {
        "extensions.autoDisableScopes" = 0;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.startup.page" = 3;
      };
      userContent = builtins.readFile ./userChrome.css;
      search.force = true;
      search.default = "Bing";
      search.engines = import ./search-engines.nix pkgs;
    };
  };
}
