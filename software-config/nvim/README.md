# Neovim
My neovim configuration.

[Neovim](https://neovim/neovim) is a fork of Vim.

Pros:
- No need of mouse
- Fast
- Use lua to config, that providing a lot of flexibility.

Cons:
- A bit confusing with nixos.

> [!NOTE]
> I'm not using nixvim because it lacks of some functionality.

## [`default.nix`](./default.nix)
The nix entry of my neovim config.

It just creates a symlink to my config.

## [`init.lua`](./init.lua)
The lua entry of my neovim config.

It just import two files.

## [`lua`](./lua/)
The config modules. See its README for detail.
