# Shell
My shell configuration.

## [`shell.nix`](./shell.nix) 
My shell.

### zsh-autosuggestion
Provides auto-suggestion that can be used by right arrow key.

Pros:
- Easy to configure

Cons:
- Right arrow is too far
- Not accurate in all times.

### zsh-vi-mode
Better vi-mode for zsh.

Pros:
- Better than built-in

Cons:
- Still distance to native

### starship
Better prompt

Pros:
- Better than built-in

Cons:
- Not working well with `nix develop`.

### fzf
Fuzzy finder

Pros:
- Easy to use

Cons:
- Need configuration

## [`terminal.nix`](./terminal.nix) 
Configures alacritty.

[Alacritty](https://github.com/alacritty/alacritty) is a terminal emulator written in Rust.

Pros:
- Easy to configure

Cons:
- No support for graphics.
