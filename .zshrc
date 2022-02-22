PATH=~/go/bin:$PATH
PATH=~/usr/local/opt/libpq/bin:$PATH

eval $(minikube docker-env)

# C pkg config paths
export PKG_CONFIG_PATH=/usr/local/opt/openssl/lib/pkgconfig

# gpg tty env variables
export GPG_TTY=$(tty)

# Aliases:
alias dm="docker-machine"
alias k="kubectl"
alias kgx="kubectl config get-contexts"
alias d="docker"
alias dps="docker ps"
alias v="nvim"
alias vim="nvim"

# Watch alias
# https://unix.stackexchange.com/questions/25327/watch-command-alias-expansion
alias watch='watch '

# pyenv init
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# Navi
eval "$(navi widget zsh)"

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="agnoster"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

export GPG_TTY=$(tty)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export LDFLAGS="-L/usr/local/opt/libpq/lib"
export CPPFLAGS="-I/usr/local/opt/libpq/include"

