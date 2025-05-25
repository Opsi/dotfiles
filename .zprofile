echo "Path 1 here is $PATH"
# default programs
export EDITOR="nvim"
export TERM="kitty"

# follow XDG base dir specification
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

# neovim
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"
# installed go packages
export PATH=$PATH:~/go/bin
# global npm packages
export PATH=~/.npm-global/bin:$PATH
export PATH="$PATH:~/.local/bin"
export LC_ALL="en_US.UTF-8"
export LANG="en_US.UTF-8"

# Created by `pipx` on 2024-10-17 12:27:35
export PATH="$PATH:~/.local/bin"
#source <(kubectl completion bash)
#alias k=kubectl
#complete -o default -F __start_kubectl k

echo "Path 2 here is $PATH"
