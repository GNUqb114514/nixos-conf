{ pkgs, ... }: {
  programs.firefox.enable = true;

  programs.firefox.languagePacks = [ "en-US" "zh-CN" ];

  programs.firefox.profiles = {
    default = {
      id = 0;
      name = "default";
      isDefault = true;
      bookmarks = {
        force = true;
        settings = import ./bookmarks.nix;
      };
      settings = {
        "extensions.autoDisableScopes" = 0;
        # "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.display.use_document_fonts" = 0;
        "browser.startup.page" = 3;
        "general.useragent.locale" = "zh-CN";
      };
      userContent = builtins.readFile ./userChrome.css;
      search.force = true;
      search.default = "bing";
      search.engines = import ./search-engines.nix pkgs;
    };
  };
}
