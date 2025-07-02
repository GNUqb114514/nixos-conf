{ lib, inputs, config, ... }: {
  programs.nvf.settings.vim = {
    options.foldlevelstart = 99;
    options.foldmethod = "expr";
    options.foldexpr = "v:lua.vim.treesitter.foldexpr()";
    options.fillchars = "fold: ,foldopen:,foldclose:";
    autocmds = [
      {
        event = ["LspAttach"];
        # group = "fold";
        callback = lib.generators.mkLuaInline ''
          function(event)
            local client = vim.lsp.get_client_by_id(event.data.client_id)
            if client and client:supports_method 'text_document/foldingRange' then
              local win = vim.api.nvim_get_current_win()
              vim.wo[win][0].foldexpr = 'v:lua.vim.lsp.foldexpr()'
            end
          end
        '';
      }
    ];

    luaConfigRC = {
      foldtext = inputs.nvf.lib.nvim.dag.entryBefore ["optionsScript"] (builtins.readFile ./fold_virt_text.lua);
    };

    options.foldtext = "v:lua.custom_foldtext()";

    highlight."Folded" = {
      fg = config.lib.stylix.colors.withHashtag.orange;
    };
  };
}
