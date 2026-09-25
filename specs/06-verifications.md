# 06 - Verifications and open items

## Verified (2026-09-25)

| Item | Result | Source |
|---|---|---|
| `ubuntu` user in the image | 22.04 does not ship it (a new user gets UID 1000); 24.04 does (`ubuntu`, UID 1000). No direct proof: Docker could not be run from WSL in this session. | Issues in poky-container and devcontainers/images |
| Copilot CLI without Node | Confirmed: `curl -fsSL https://gh.io/copilot-install \| bash`; installs into `$HOME/.local` (non-root), supports `PREFIX` and `VERSION`. | https://github.com/github/copilot-cli |
| Claude Code installer | Confirmed: `curl -fsSL https://claude.ai/install.sh \| bash`; launcher at `~/.local/bin/claude`; requires Ubuntu 20.04+ and 4 GB RAM; self-updates. | https://code.claude.com/docs/en/setup |
| `pipx` on 22.04 | Version 1.0.0, `universe` repository. | https://packages.ubuntu.com/jammy/pipx |

## To check during implementation
1. Confirm with Docker that `ubuntu:22.04` does not ship the `ubuntu` user.
2. Confirm the `universe` repository is enabled in the image for `pipx` (otherwise `pip install --user pipx`).
3. ~~Review the current `.gitattributes`~~ Done: it only contained `* text=auto`; replaced by `* text=auto eol=lf`.
4. Handle network exposure of the container (password is weak by design).

## Out of scope
Connecting VS Code (done manually via terminal and volumes) and `remoteUser` configuration.
