# dotfiles

Git, [GitHub CLI](https://cli.github.com/), shell, [omp](https://omp.sh), and agent-skill setup for macOS and Linux.

```shell
./install.sh
```

The script is safe to rerun. It links or includes files from this repository and moves an existing file aside once (`*.before-dotfiles`) instead of overwriting it. Coder runs it in new workspaces through the dotfiles module.

- `git/`: shared config, plus delta and 1Password signing where available.
- GitHub CLI (`gh`): installed if missing through Homebrew, or apt on Debian-like hosts with passwordless sudo. Otherwise, the script prints a manual-install link. Authenticate once per machine with `gh auth login`; credentials are not stored here.
- `shell/common.sh`: aliases and `PATH`, sourced from `~/.bashrc` and `~/.zshrc`.
- `omp/config.yml`: omp settings, linked to `~/.omp/agent/config.yml`. Logins are not stored here; run `omp login` once per machine.
- `bazel/bazelrc`: Bazel module registries (Bazel Central Registry and brainhive), linked to `~/.bazelrc`.
- `skills.txt`: global agent skills (repository and folder), copied to `~/.agents/skills` and linked for Claude Code. Installed skills are kept on reruns; `DOTFILES_UPDATE_SKILLS=1 ./install.sh` refreshes them. Skills you keep as symlinks to a local checkout are left alone.
  Includes [HyperFrames](https://github.com/heygen-com/hyperframes/tree/main/skills/hyperframes), the video-creation router; it installs specialized workflows on demand.
