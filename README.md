# docker-ubuntu-devbox

A lightweight Ubuntu Docker image, managed with PowerShell scripts, for installing an AI client (Claude Code, GitHub Copilot CLI, etc.) inside an isolated environment.

## Overview

- **Image:** minimal Ubuntu 22.04 with generic development tools and Python 3. It ships with no user and no AI client.
- **Container:** the user is created when the container is created (not in the image); the main process runs as that user.
- **PowerShell scripts:** create and delete images; create, start, stop and connect to containers.
- **AI clients:** installed inside the container with bash scripts stored on a mounted volume. **One client per container.**
- **Volumes:** two host folders (`proyectos` and `resources`) mounted inside the container.
- **Prefix (critical):** `dkdb`. Every name (image, container, user) is `dkdb-<name>`.
- **Language:** documentation, scripts, messages and comments are all written in English.

## Methodology (CoT)

Each spec follows the pattern **Context -> Reasoning -> Decision -> Consequences**. Every decision was validated one by one with the project owner before being written down here.

## Specs

| # | Spec | Content |
|---|------|---------|
| 01 | [Global conventions](specs/01-conventions.md) | Prefix, naming, language, encoding, LF, menus |
| 02 | [Docker image](specs/02-image.md) | Base, packages, colors, entrypoint |
| 03 | [PowerShell scripts](specs/03-powershell-scripts.md) | Image and container management |
| 04 | [Volumes and user](specs/04-volumes-user.md) | Host paths, mounts, user, sudo |
| 05 | [AI client installation](specs/05-ai-clients.md) | Bash scripts for Claude Code and Copilot CLI |
| 06 | [Verifications and open items](specs/06-verifications.md) | Checks already done and items still to validate |
