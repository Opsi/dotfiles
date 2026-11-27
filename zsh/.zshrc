# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Add in snippets
zinit snippet OMZL::git.zsh
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::command-not-found

# Load completions (full security check only if dump older than 24h)
autoload -Uz compinit
() {
  setopt local_options extended_glob
  if [[ -n ${ZDOTDIR:-$HOME}/.zcompdump(#qN.mh+24) ]]; then
    compinit
  else
    compinit -C
  fi
}

zinit cdreplay -q

# Keybindings
bindkey -e  # Use Emacs keybindings as default
bindkey "^[[1;5C" forward-word  # Ctrl + Right Arrow
bindkey "^[[1;5D" backward-word # Ctrl + Left Arrow
# edit command in editor
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
# magic space to expand history like "!!" or "!$"
bindkey ' ' magic-space

# suffix aliases to open files by extension
alias -s json='$EDITOR'
alias -s yaml='bat -l yaml'
alias -s md=bat
alias -s txt=bat
alias -s log='$EDITOR'
alias -s py='$EDITOR'
alias -s js='$EDITOR'
alias -s ts='$EDITOR'
alias -s tsx='$EDITOR'
alias -s go='$EDITOR'
alias -s rs='$EDITOR'
alias -s html=xdg-open
alias -s pdf=xdg-open
alias -s mp4=xdg-open
alias -s png=xdg-open

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
ALIAS_FILE="${XDG_CONFIG_HOME:-$HOME/.config}/shell/alias"
[ -f "$ALIAS_FILE" ] && source "$ALIAS_FILE"
unset ALIAS_FILE

# Shell integrations
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

# zoxide
if command -v zoxide >/dev/null 2>&1; then
  eval "$(zoxide init zsh)"
fi

# starship
if command -v starship >/dev/null 2>&1; then
  export STARSHIP_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/starship/starship.toml"
  eval "$(starship init zsh)"
fi

# pnpm
export PNPM_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# fnm
FNM_PATH="${XDG_DATA_HOME:-$HOME/.local/share}/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  if command -v fnm >/dev/null 2>&1; then
    eval "$(fnm env)"
  fi
fi
