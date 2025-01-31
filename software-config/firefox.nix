{ pkgs, ... }: {
  programs.firefox.enable = true;

  programs.firefox.languagePacks = [ "en-US" "zh_CN" ];

  programs.firefox.profiles = {
    default = {
      id = 0;
      name = "default";
      isDefault = true;
      bookmarks = [
      {
        name = "References";
        bookmarks = [
        {
          name = "Git submodules";
          url = "https://zhuanlan.zhihu.com/p/87053283";
        }
        {
          name = "Python style guides";
          bookmarks = [
          {
            name = "PEP 8 (coding)";
            url = "https://peps.python.org/pep-0008/";
          }
          {
            name = "PEP 257 (documenting)";
            url = "https://peps.python.org/pep-0257/";
          }
          ];
        }
        ];
      }
      {
        name = "Tutorials";
        bookmarks = [
        {
          name = "Nix and flakes";
          url = "https://nixos-and-flakes.thiscute.world";
        }
        ];
      }
      {
        name = "Toolbar";
        toolbar = true;
        bookmarks = [
        {
          name = "Mailbox";
          url = "https://outlook.live.com/mail/";
        }
        {
          name = "Bilibili";
          url = "https://bilibili.com";
        }
        {
          name = "GitHub";
          url = "https://github.com";
        }
        {
          name = "Conventional commits";
          url = "https://www.conventionalcommits.org/zh-hans/v1.0.0/#specification";
        }
        {
          name = "DeepL";
          url = "https://www.deepl.com/zh/translator";
        }
        ];
      }
      ];
      settings = {
        "extensions.autoDisableScopes" = 0;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      userContent = ''
        @-moz-document domain("bing.com") {
          h1,h2,h3,h4,h5,h6 { font-family: sans-serif !important; }
        }
      p,li { font-family: sans-serif !important; }
      @-moz-document domain("github.com") {
        a.Link--primary { font-family: sans-serif !important; }
      }
      '';
      search.force = true;
      search.default = "Bing";
      search.engines = {
        "Nix Packages" = {
          id = "nix-packages";
          description = "Search for nixpkgs packages";
          urls = [{
            template = "https://search.nixos.org/packages";
            params = [
            { name = "type"; value = "packages"; }
            { name = "query"; value = "{searchTerms}"; }
            { name = "channel"; value = "unstable"; }
            ];
          }];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@nix-packages" ];
        };

        "Nix Options" = {
          id = "nix-options";
          description = "Search for nix options";
          urls = [{
            template = "https://search.nixos.org/options";
            params = [
            { name = "type"; value = "options"; }
            { name = "channel"; value = "unstable"; }
            { name = "query"; value = "{searchTerms}"; }
            ];
          }];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = [ "@nix-options" ];
        };

        "Mycroft" = {
          id = "mycroft";
          description = "Search search engines in Mycroft project";
          urls = [{
            template = "https://mycroftproject.com/search-engines.html";
            params = [
            { name = "name"; value = "{searchTerms}"; }
            ];
          }];
          definedAliases = [ "@mycroft" ];
          iconURL = "https://mycroftproject.com/favicon.ico";
        };

        "Bilibili" = {
          id = "bilibili";
          description = "Search things on bilibili";
          urls = [{
            template = "https://search.bilibili.com/all";
            params = [
            { name = "keyword"; value = "{searchTerms}"; }
            ];
          }];
          definedAliases = [ "@bilibili" ];
          iconURL = "https://i0.hdslb.com/bfs/static/jinkela/long/images/favicon.ico";
        };

        "Noogle" = {
          id = "noogle";
          description = "Search nix functions";
          urls = [{
            template = "https://noogle.dev/q";
            params = [
              { name = "term"; value = "{searchTerms}"; }
            ];
          }];
          definedAliases = [ "@noogle" ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
        };

        "GitHub" = {
          id = "github";
          description = "Search on github";
          urls = [{
            template = "https://github.com/search";
            params = [
              { name = "q"; value = "{searchTerms}"; }
              { name = "ref"; value = "opensearch"; }
            ];
          }];
          icon = "https://github.com/favicon.ico";
          definedAliases = [ "@github" "@gh" ];
        };
      };
    };
  };
}
