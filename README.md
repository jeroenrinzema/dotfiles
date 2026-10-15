# dotfiles

Git, [GitHub CLI](https://cli.github.com/), shell, [omp](https://omp.sh), and agent-skill setup for macOS and Linux.

```shell
./install.sh
```

The script is safe to rerun. It links or includes files from this repository and moves an existing file aside once (`*.before-dotfiles`) instead of overwriting it. Coder runs it in new workspaces through the dotfiles module.

- `git/`: shared config and SSH commit signing, plus delta where available and the 1Password signer on macOS.
- GitHub CLI (`gh`): installed if missing through Homebrew, or apt on Debian-like hosts with passwordless sudo. Otherwise, the script prints a manual-install link. Authenticate once per machine with `gh auth login`; credentials are not stored here.
- `shell/common.sh`: aliases and `PATH`, sourced from `~/.bashrc` and `~/.zshrc`.
- `omp/config.yml`: omp settings, linked to `~/.omp/agent/config.yml`. Logins are not stored here; run `omp login` once per machine.
- `bazel/bazelrc`: Bazel module registries (Bazel Central Registry and brainhive), linked to `~/.bazelrc`.
- `skills.txt`: global agent skills (repository and folder), copied to `~/.agents/skills` and linked for Claude Code. Installed skills are kept on reruns; `DOTFILES_UPDATE_SKILLS=1 ./install.sh` refreshes them. Skills you keep as symlinks to a local checkout are left alone.
  Includes [HyperFrames](https://github.com/heygen-com/hyperframes/tree/main/skills/hyperframes), the video-creation router; it installs specialized workflows on demand.

## Signed commits in Coder devcontainers

`git/gitconfig` enables SSH commit signing with the public key stored in this repository. Linux uses `ssh-keygen` and the key available through `SSH_AUTH_SOCK`; `git/macos.gitconfig` overrides only the signer to use 1Password directly. Private keys stay in 1Password, never in dotfiles or containers.

Run `./install.sh` in each environment to include these settings. Git must support SSH signing (2.34+) and the container needs `ssh-keygen` with SSH signing support. Remove conflicting signing settings from your local `~/.gitconfig` if they override the includes; inspect them with:

```shell
git config --show-origin --get-regexp \
  '^(user\.signingkey|gpg\.format|gpg\.ssh\.program|commit\.gpgsign)$'
```

On your Mac, enable the 1Password SSH agent in 1Password settings. Connect directly to the devcontainer agent, not just its parent workspace:

```shell
coder ssh -A \
  --identity-agent "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" \
  <workspace>.<agent>
```

For example, `brainpod.brainpod` is the brainpod devcontainer. In that session, `ssh-add -l` must list the configured signing key, whose fingerprint is `SHA256:vu9/E1LUsHzKrmYIZxYqv35WT7CYFtjVLSKhLi6DD1o`. Approve signing requests in 1Password on your Mac.

For OpenSSH or an SSH-based desktop IDE, configure forwarding on your Mac:

```shell
coder config-ssh --yes -o ForwardAgent=yes
```

This replaces the saved `config-ssh` options; pass any other custom `-o` options you need in the same command. Do not use `--use-previous-options` when first enabling forwarding: it can keep the old options instead of applying the new one.

Ensure `~/.ssh/config` selects the 1Password agent for Coder hosts. Keep this block outside Coder's managed section and before any broader `Host *` defaults:

```sshconfig
Host coder.* *.coder
    IdentityAgent "~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
```

In Orca, use the Coder SSH host for the devcontainer (for example, `brainpod.brainpod.me.coder`). Reconnect an already-open Coder connection after changing the SSH options, then open a fresh terminal and check `ssh-add -l` there. Existing connections and terminals do not automatically acquire the forwarded socket.

Forward only to trusted workspaces: processes running as your remote user can request use of the forwarded keys. Forwarding lasts for the connection and is not automatically available in Coder browser terminals, background jobs, or unrelated sessions. Without the signing key, commits fail rather than silently becoming unsigned.

Register the public key on GitHub as a **Signing key** under **Settings → SSH and GPG keys** for GitHub to show verified commits. Authentication-key registration alone is not enough.

References: [Coder devcontainer SSH access](https://coder.com/docs/user-guides/devcontainers/working-with-dev-containers), [1Password agent forwarding](https://developer.1password.com/docs/ssh/agent/forwarding/).
