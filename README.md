# dotfiles

Clone this repository to `~/dotfiles`.

Install GNU Stow:

```bash
sudo apt install stow
```

Stow the modules you want:

```bash
cd ~/dotfiles
stow --no-folding zsh bash nvim starship kitty ghostty sway waybar wofi mako
```

Unstow a module:

```bash
stow -D zsh
```
