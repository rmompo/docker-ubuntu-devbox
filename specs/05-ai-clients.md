# 05 - AI client installation

## Context
One AI client (Claude Code or GitHub Copilot CLI) is installed inside the container. Installation uses bash scripts stored on the `resources` volume.

## Reasoning
1. The image is generic -> the client is installed afterwards, per container.
2. Owner's rule: **one client per container**; for another client, create another container.
3. The scripts live on the host (volume) -> they can be edited without rebuilding the image.
4. Files are created on Windows -> they must be LF and UTF-8; Windows does not keep the execute bit -> run them with `bash script.sh`.
5. Node is excluded from the image -> Copilot CLI is installed with its standalone installer, which does not need it.
6. Both clients install into `~/.local/bin` -> make sure it is on the PATH.

## Decision
- **Source of truth:** `scripts/bash/` in the repository (versioned in git).
- **Deployed copy:** `C:\shared\devbox\resources\devbox-scripts\` (inside the container: `/home/<user>/devbox/resources/devbox-scripts/`). `container-create` copies the repo scripts there, overwriting (spec 03); the copy must not be edited by hand.
- **Claude Code:** `curl -fsSL https://claude.ai/install.sh | bash` (latest version; leaves `~/.local/bin/claude`).
- **Copilot CLI:** `curl -fsSL https://gh.io/copilot-install | bash` (no Node needed; installs into `$HOME/.local` for non-root users).
- **PATH:** each script appends `~/.local/bin` to `.bashrc` idempotently.
- **Exclusivity check:** before installing, the script looks for the other client (`claude` or `copilot`, on the PATH or in `~/.local/bin`). If found, it installs nothing, prints that another container must be used, and exits with an error code. If the client is the same one, it continues (reinstall or update).
- **Language:** script comments and messages are in English.

## Consequences
- Depends on two third-party installers; if they change, the scripts need review.
- The one-client rule is enforced by the script, not by Docker.
