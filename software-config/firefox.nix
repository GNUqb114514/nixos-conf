{ pkgs, ... }: {
  programs.firefox.enable = true;

  programs.firefox.languagePacks = [ "en-US" "zh-CN" ];

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
        (extension "deepl-translate" "firefox-extension@deepl.com")
        (extension "mozlz4-edit" "{0981817c-71b3-4853-a801-481c90af2e8e}")
    ];
  };
}
