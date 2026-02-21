{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.user.nvim;
in
{
  options.user.nvim = with lib; {
    completion = {
      enable = mkEnableOption "blink.cmp";
      snippets = mkEnableOption "snippet support";
      lazydev = mkEnableOption "lazydev";
    };
  };

  config.warnings = lib.optionals (cfg.completion.lazydev && !config.user.programming.lua) [
    "Lazydev requires lua programmming environment."
  ];

  config.programs.nvf.settings.vim = lib.mkMerge [
    (lib.mkIf cfg.completion.enable {
      autocomplete.blink-cmp = {
        enable = true;
        friendly-snippets.enable = cfg.completion.snippets;
        mappings = {
          scrollDocsUp = "<M-k>";
          scrollDocsDown = "<M-j>";
        };
        setupOpts = {
          appearance = {
            nerd_font_variant = "normal";
          };
          keymap = {
            "<Esc>" = [
              (lib.generators.mkLuaInline ''
                function (cmp)
                  if cmp.snippet_active() then return cmp.hide()
                  else return end
                end
              '')
              "fallback"
            ];
          };
          sources = lib.mkMerge [
            (lib.mkIf cfg.completion.lazydev {
              default = lib.mkBefore [ "lazydev" ];
              providers.lazydev = {
                name = "LazyDev";
                module = "lazydev.integrations.blink";
                score_offset = 100;
              };
            })
          ];
          fuzzy.implementation = "prefer_rust_with_warning";
        };
      };
    })
    (lib.mkIf cfg.completion.lazydev {
      languages = {
        lua.lsp.lazydev.enable = true;
      };
    })
  ];
}
