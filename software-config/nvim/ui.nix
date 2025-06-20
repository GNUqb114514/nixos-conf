{ ... }: {
  programs.nvf.settings.vim = {
    # Status line
    statusline.lualine = {
      enable = true;
      disabledFiletypes = ["sagaoutline"];
    };

    # tabline.nvimBufferline.enable = true;
    # tabline.nvimBufferline.setupOpts.options.modified_icon = "•";

    # Indent
    visuals.indent-blankline.enable = true;

    # Notify
    notify.nvim-notify.enable = true;
  };
}
