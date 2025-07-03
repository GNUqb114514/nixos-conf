# Neovim

> [!NOTE] Pros and Cons of Neovim
> [Neovim](https://neovim/neovim) is a fork of Vim.
>
> Pros:
>
> - No need of mouse
> - Fast
>
> Cons:
>
> - A bit confusing with nixos.

The configuration is managed by nvf.

> [!NOTE] Pros and Cons of nvf
> [nvf](https://github.com/NotAShelf/nvf) is a configuration framework for
> Neovim.
>
> Pros:
>
> - Flexible and customizable
> - Full lazy loading support
>
> Cons:
>
> - Sometimes add some random configurations.

## [`default.nix`](./default.nix)

The entry of my neovim config.

### [vim-barbaric](https://github.com/rlue/vim-barbaric)

IME management in neovim.

Pros:

- Buffer-local managements

Cons:

- Writing in Vimscript, that means it can't be auto-loaded.

### [neogit](https://NeogitOrg/neogit)

Git interface in neovim.

Pros:

- Easy to use.

Cons:

- Complex keybindings in certain cases.

### Custom folding indicator copied from [A kind uploader](https://github.com/patricorgi/dotfiles)

Custom folding indicator.

Pros:

- Beautiful.

Cons:

- Complex configuration.

## [`graphical.nix`](./graphical.nix)

The settings enabled only if TUI enabled.

### [lualine.nvim](https://github.com/nvimdev/lspsaga.nvim)

Status line.

Pros:

- Clean and beautiful.

## [`utility.nix`](./utility.nix)

Useful utilities.

### [flash.nvim](https://github.com/folke/flash.nvim)

Cursor movement by searching.

Pros:

- Fast.

Cons:

- Confusing `fFtT` interface.

### [nvim-window-picker](https://github.com/s1n7ax/nvim-window-picker)

Pick windows.

Pros:

- Fast and customizable.

Cons:

- Complex settings.

## [`programming`](./programming.nix)

Programming-related settings.

## [`completion.nix`](./completion.nix)

Auto-completion configurations.
