# Software configuration

Here are configurations of softwares.

> [!note]
> Most of practical configurations are moved to [modules](/modules),
> and configs here are not very practical.

## [`nh-clean.nix`](./nh-clean.nix)

Here makes the clean job of [`nh`](https://gtihub.com/nix-community/nh).
It runs weekly.

## [`firefox/`](./firefox/)

Here is the evilest part -- The firefox configuration.
It contains both system-wide and user local settings,
and makes them completely be chaos.
We should get rid of them, and we will --
but before it, we should put some signs to make people be careful with it.

Pros:

- Almost nothing

Cons:

- Unreadable configuration

> *Every program should put their configurations into a single plain text file.
> -- Unknown NixOS user*

## [`de/`](./de/)

Here is my desktop environment (DE for short) configuration.
It is complicated but in order (comparingly). Details are in its README.
