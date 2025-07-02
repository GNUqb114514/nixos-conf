{ lib, ... }: {
  programs.nvf.settings.vim = {
    autocomplete.blink-cmp = {
      enable = true;
      friendly-snippets.enable = true;
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
        sources = {
          default = lib.mkBefore ["lazydev"];
          providers.lazydev = {
            name = "LazyDev";
            module = "lazydev.integrations.blink";
            score_offset = 100;
          };
        };
        fuzzy.implementation = "prefer_rust_with_warning";
      };
    };
  };
}
