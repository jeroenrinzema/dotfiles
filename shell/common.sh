# shellcheck shell=bash
# Sourced from ~/.bashrc and ~/.zshrc by install.sh. Keep it portable between
# bash and zsh, and free of machine-specific paths.

case ":${PATH}:" in
  *":${HOME}/.local/bin:"*) ;;
  *) export PATH="${HOME}/.local/bin:${PATH}" ;;
esac

alias k="kubectl"
alias kgx="kubectl config get-contexts"
alias d="docker"
alias dps="docker ps"
# Lets `watch` expand aliases in its command.
alias watch="watch "

if command -v nvim >/dev/null 2>&1; then
  alias v="nvim"
  alias vim="nvim"
fi
