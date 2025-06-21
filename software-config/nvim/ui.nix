{ ... }: {
  programs.nvf.settings.vim = {
    # Status line
    statusline.lualine = {
      enable = true;
      disabledFiletypes = ["sagaoutline"];
    };

    # Indent
    visuals.indent-blankline.enable = true;

    # Notify
    notify.nvim-notify.enable = true;
  };
}
