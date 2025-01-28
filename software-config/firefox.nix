{ pkgs, ... }: {
  programs.firefox.enable = true;

  programs.firefox.languagePacks = [ "en-US" "zh_CN" ];

  programs.firefox.policies = {
    ExtensionSettings = let
        external-extension = url: uuid: {
	  name = uuid;
	  value = {
	    install_url = url;
            installation_mode = "force_installed";
	  };
	};
	extension = shortId: uuid: external-extension "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}" uuid;
      in builtins.listToAttrs [
        (extension "sidebery" "{3c078156-979c-498b-8990-85f7987dd929}")
	(external-extension "https://github.com/mkaply/queryamoid/releases/download/v0.1/query_amo_addon_id-0.1-fx.xpi" "queryamoid@kaply.com")
      ];
  };

  programs.firefox.profiles = {
    default = {
      id = 0;
      name = "default";
      isDefault = true;
      bookmarks = [
        {
          name = "Refrences";
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
      p { font-family: sans-serif; }
      .markdown-body p,li { font-family: sans-serif !important; }
      @-moz-document domain("github.com") {
        a { font-family: sans-serif !important; }
      }
      '';
      search.default = "Bing";
      search.engines = {
      };
      #      extensions = with pkgs; [
      # nur.repos.rycee.firefox-addons.sidebery
      #      ];
    };
  };
}
