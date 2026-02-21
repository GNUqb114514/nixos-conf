pkgs: {
  "Nix Packages" = {
    id = "nix-packages";
    description = "Search for nixpkgs packages";
    urls = [
      {
        template = "https://search.nixos.org/packages";
        params = [
          {
            name = "type";
            value = "packages";
          }
          {
            name = "query";
            value = "{searchTerms}";
          }
          {
            name = "channel";
            value = "unstable";
          }
        ];
      }
    ];
    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    definedAliases = [ "@nix-packages" ];
  };

  "Nix Options" = {
    id = "nix-options";
    description = "Search for nix options";
    urls = [
      {
        template = "https://search.nixos.org/options";
        params = [
          {
            name = "type";
            value = "options";
          }
          {
            name = "channel";
            value = "unstable";
          }
          {
            name = "query";
            value = "{searchTerms}";
          }
        ];
      }
    ];
    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
    definedAliases = [ "@nix-options" ];
  };

  "Mycroft" = {
    id = "mycroft";
    description = "Search search engines in Mycroft project";
    urls = [
      {
        template = "https://mycroftproject.com/search-engines.html";
        params = [
          {
            name = "name";
            value = "{searchTerms}";
          }
        ];
      }
    ];
    definedAliases = [ "@mycroft" ];
    icon = "https://mycroftproject.com/favicon.ico";
  };

  "Bilibili" = {
    id = "bilibili";
    description = "Search things on bilibili";
    urls = [
      {
        template = "https://search.bilibili.com/all";
        params = [
          {
            name = "keyword";
            value = "{searchTerms}";
          }
        ];
      }
    ];
    definedAliases = [ "@bilibili" ];
    icon = "https://i0.hdslb.com/bfs/static/jinkela/long/images/favicon.ico";
  };

  "Noogle" = {
    id = "noogle";
    description = "Search nix functions";
    urls = [
      {
        template = "https://noogle.dev/q";
        params = [
          {
            name = "term";
            value = "{searchTerms}";
          }
        ];
      }
    ];
    definedAliases = [ "@noogle" ];
    icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
  };

  "GitHub" = {
    id = "github";
    description = "Search on github";
    urls = [
      {
        template = "https://github.com/search";
        params = [
          {
            name = "q";
            value = "{searchTerms}";
          }
          {
            name = "ref";
            value = "opensearch";
          }
        ];
      }
    ];
    icon = "https://github.com/favicon.ico";
    definedAliases = [
      "@github"
      "@gh"
    ];
  };
}
