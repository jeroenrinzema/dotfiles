# dotfiles

Git, shell, [omp](https://omp.sh), and agent-skill setup for macOS and Linux.

```shell
./install.sh
```

The script is safe to rerun. It links or includes files from this repository and moves an existing file aside once (`*.before-dotfiles`) instead of overwriting it. Coder runs it in new workspaces through the dotfiles module.

- `git/`: shared config, plus delta and 1Password signing where available.
- `shell/common.sh`: aliases and `PATH`, sourced from `~/.bashrc` and `~/.zshrc`.
- `omp/config.yml`: omp settings, linked to `~/.omp/agent/config.yml`. Logins are not stored here; run `omp login` once per machine.
- `bazel/bazelrc`: Bazel module registries (Bazel Central Registry and brainhive), linked to `~/.bazelrc`.
- `skills.txt`: global agent skills (repository and folder), copied to `~/.agents/skills` and linked for Claude Code. Skills you keep as symlinks to a local checkout are left alone.
