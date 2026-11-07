# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## Terminal shortcuts

| Shortcut | Action |
| --- | --- |
| Option+T | Toggle the selected floating shell tab (98% × 96%, purple rounded border) |
| Option+O | Toggle `omp` in a separate 99% × 99% floating terminal with a blue rounded border |
| Option+G | Toggle LazyGit in a 98% × 98% floating window |
| Option+R | Toggle the `rein ui` floating dashboard (keeps its session when hidden) |
| Option+Shift+H / Option+Shift+L | Move left / right through existing shell tabs (wraps around) |
| Option+Shift+1…5 | Switch to shell tab 1–5; create its shell if it does not exist |

These shortcuts work in normal and terminal mode. Shell tabs have independent sessions; the window bar shows only running shell tabs, omitting unopened or exited tabs. A closed shell tab is recreated when selected. The terminal emulator must send Option as Meta and preserve Shift for Neovim to receive these keys (on US layouts, Shift+1…5 produces `!@#$%`).

Option+T and Option+O preserve each terminal's scrolled-up cursor and scroll position when hidden or switching focus between the shell and `omp`, including shell tab switches. At the bottom, returning to the terminal resumes input mode.
