#!/usr/bin/env bash
# Set up git, the shell, omp, and agent skills on macOS or Linux. Safe to rerun.
# Coder's dotfiles module runs this in new workspaces; elsewhere run ./install.sh.
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

log() { echo "==> $*"; }

# Symlink $1 to $2. An existing file is moved aside once, never overwritten.
link() {
  local src=$1 dest=$2
  if [ -L "${dest}" ] && [ "$(readlink "${dest}")" = "${src}" ]; then
    return
  fi
  mkdir -p "$(dirname "${dest}")"
  if [ -e "${dest}" ] || [ -L "${dest}" ]; then
    mv "${dest}" "${dest}.before-dotfiles"
  fi
  ln -s "${src}" "${dest}"
}

# Git: include this repo's files instead of owning ~/.gitconfig, which other
# tools (such as the Brainpod dev container bootstrap) also write to.
git_include() {
  git config --global --get-all include.path 2>/dev/null | grep -qxF "$1" ||
    git config --global --add include.path "$1"
}

log "Git"
git_include "${DOTFILES}/git/gitconfig"
if command -v delta >/dev/null 2>&1; then
  git_include "${DOTFILES}/git/delta.gitconfig"
fi
if [ "$(uname -s)" = Darwin ]; then
  git_include "${DOTFILES}/git/macos.gitconfig"
fi
git config --global core.excludesFile "${DOTFILES}/git/ignore"
if command -v git-lfs >/dev/null 2>&1; then
  git lfs install --skip-repo >/dev/null
fi

log "Shell"
source_line=". \"${DOTFILES}/shell/common.sh\""
for rc in "${HOME}/.bashrc" "${HOME}/.zshrc"; do
  if [ "${rc}" = "${HOME}/.zshrc" ] && ! command -v zsh >/dev/null 2>&1; then
    continue
  fi
  touch "${rc}"
  if ! grep -qxF "${source_line}" "${rc}"; then
    printf '\n%s\n' "${source_line}" >>"${rc}"
  fi
done

log "Bazel"
# Registries every checkout needs, including worktrees without .bazelrc.user.
link "${DOTFILES}/bazel/bazelrc" "${HOME}/.bazelrc"

# Orca's SSH relay needs Node.js 18+ with npm and compiles node-pty (make, a
# C++ compiler, python3). Only on Debian-like hosts with passwordless sudo, such
# as dev containers; elsewhere install them yourself.
orca_packages=(nodejs npm build-essential python3)
if command -v apt-get >/dev/null 2>&1 && sudo -n true 2>/dev/null &&
  ! dpkg -s "${orca_packages[@]}" >/dev/null 2>&1; then
  log "Orca relay packages"
  sudo apt-get update -qq
  sudo DEBIAN_FRONTEND=noninteractive apt-get install -y -qq "${orca_packages[@]}"
fi

log "omp"
if ! command -v omp >/dev/null 2>&1 && [ ! -x "${HOME}/.local/bin/omp" ]; then
  curl -fsSL https://raw.githubusercontent.com/can1357/oh-my-pi/main/scripts/install.sh | sh -s -- --binary
fi
link "${DOTFILES}/omp/config.yml" "${HOME}/.omp/agent/config.yml"

log "Skills"
# Shallow-clone each repository once, copy each listed folder to ~/.agents/skills
# (read by omp), and link it for Claude Code. Installed skills are kept so a
# rerun (Coder runs this on every start) stays fast; DOTFILES_UPDATE_SKILLS=1
# refreshes them. A skill that is a symlink points at a local checkout you are
# editing and is never touched.
skills_tmp="$(mktemp -d)"
trap 'rm -rf "${skills_tmp}"' EXIT
mkdir -p "${HOME}/.agents/skills" "${HOME}/.claude/skills"
while read -r repo path; do
  case "${repo}" in '' | '#'*) continue ;; esac
  name="$(basename "${path}")"
  dest="${HOME}/.agents/skills/${name}"
  if [ -L "${dest}" ]; then
    continue
  fi
  if [ -d "${dest}" ] && [ "${DOTFILES_UPDATE_SKILLS:-0}" != 1 ]; then
    continue
  fi
  clone="${skills_tmp}/${repo//\//_}"
  if [ ! -d "${clone}" ]; then
    git clone --quiet --depth 1 "https://github.com/${repo}.git" "${clone}"
  fi
  rm -rf "${dest}"
  cp -R "${clone}/${path}" "${dest}"
  if [ ! -e "${HOME}/.claude/skills/${name}" ] && [ ! -L "${HOME}/.claude/skills/${name}" ]; then
    ln -s "${dest}" "${HOME}/.claude/skills/${name}"
  fi
done <"${DOTFILES}/skills.txt"

log "Done. Log in to omp once per machine: omp login"
