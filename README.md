# nixos-conf

My personal nixos config.

> [!WARNING]
> This configuration is very ugly and unpractical, so do not copy it directly.

## Overview

- High-level
  - Unstable nixpkgs & NUR & home-manager
  - [stylix](https://github.com/danth/stylix) to manager color scheme with
    [tokyonight](https://github.com/folke/tokyonight.nvim)
  - A devshell
  - Impermanence config without [impermanence](https://github.com/nix-community/impermanence)
    > [!NOTE]
    > It will be with it.
  - A lot of substituters for nixpkgs
    > [!NOTE]
    > My network sucks.
  - GRUB as bootloader
    > [!NOTE]
    > I need to change default system.
- DE
  - [Niri](https://github.com/YaLTeR/niri) configured by [niri-flake](https://github.com/sodiboo/niri-flake)
  - i3status-rust and i3bar-river
  - [Fcitx 5](https://github.com/fcitx/fcitx5)
- [Neovim](https://github.com/neovim/neovim) configured in plain lua
- Shell: Zsh
  > [!NOTE]
  > I've tried fish but it is missing fzf-tab.
  - [zsh-vi-mode](https://github.com/jeffreytse/zsh-vi-mode)
  - Starship
  - Fzf
- Utilities
  - [`nh`](https://github.com/nix-community/nh) with weekly clean job
  - A lot of other miscellaneous utilities
- Miscellaneous
  - Firefox, the hardest one.

## Todo

- [ ] Document everything
- [ ] Find a better browser (or write one)
- [ ] Make this config more practical
- [ ] Try more new things
