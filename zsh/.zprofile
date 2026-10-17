## Set your preferred text editor
export EDITOR="nvim"
export VISUAL="$EDITOR"

# Set locale and language settings when the locales exist on this machine
_has_locale() {
  locale -a 2>/dev/null | grep -Eiq "^$1$"
}

if _has_locale 'en_GB\.utf-?8'; then
  export LANG="en_GB.UTF-8"
fi

# Set locale for time and date formatting to German
if _has_locale 'de_DE\.utf-?8'; then
  export LC_TIME="de_DE.UTF-8"
fi

unset -f _has_locale

# XDG Base Directory Specification variables
# Helps keep your home directory tidy
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_BIN_HOME="$HOME/.local/bin"

# --- PATH Configuration ---

# Add user's personal bin directory if it exists
if [ -d "$HOME/bin" ]; then
  export PATH="$HOME/bin:$PATH"
fi

# Add XDG bin directory to the PATH
if [ -d "$XDG_BIN_HOME" ]; then
  export PATH="$XDG_BIN_HOME:$PATH"
fi

# Add npm global install directory to the PATH
# The exact path can vary based on npm configuration and OS
# This is a common location, adjust if yours is different
if [ -d "$HOME/.npm-global/bin" ]; then
  export PATH="$HOME/.npm-global/bin:$PATH"
fi

# Add Go executables to the PATH
# This is the default installation location for Go user installs
if [ -d "/usr/local/go/bin" ]; then
  export PATH="/usr/local/go/bin:$PATH"
fi

# Add the Go user bin directory (for go install commands)
# The GOBIN environment variable is typically set in .zshrc,
# but including the default user bin path here is also common.
# If you set GOBIN elsewhere, ensure this path is correct.
if [ -d "$HOME/go/bin" ]; then
  export PATH="$HOME/go/bin:$PATH"
fi

# neovim
if [ -d "/opt/nvim-linux-x86_64/bin" ]; then
  export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
fi
