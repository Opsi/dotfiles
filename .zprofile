## Set your preferred text editor
export EDITOR="nvim"
export VISUAL="$EDITOR"
export TERM="kitty"

# Set locale and language settings
# LC_ALL overrides all other locale settings
# LANG sets the default locale if specific LC_* variables are not set
export LANG="en_GB.UTF-8"
export LC_ALL="en_GB.UTF-8"

# Set locale for time and date formatting to German
export LC_TIME="de_DE.UTF-8"

# XDG Base Directory Specification variables
# Helps keep your home directory tidy
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# --- PATH Configuration ---

# Add user's personal bin directory if it exists
if [ -d "$HOME/bin" ]; then
  export PATH="$HOME/bin:$PATH"
fi

# Add pipx executables to the PATH if the directory exists
# pipx installs executables in ~/.local/bin by default
if [ -d "$HOME/.local/bin" ]; then
  export PATH="$HOME/.local/bin:$PATH"
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
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
