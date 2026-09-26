# 03 - PowerShell scripts

## Context
Daily management of images and containers must be fast, without remembering Docker commands or full names.

## Reasoning
1. Every resource carries the prefix -> scripts can list them and offer them in a menu.
2. Picking from a list avoids typing errors -> common navigable menu (spec 01).
3. Each script does one thing -> one script per operation.
4. Destructive and create operations work on a single item at a time -> single selection.

## Decision

| Script | Behavior |
|---|---|
| `image-create` | Asks only for the image name (default `ubuntu`) and builds `dkdb-<name>`. |
| `image-delete` | Menu of `dkdb-` images; deletes the chosen one (single selection). |
| `container-create` | Asks for the image (as `image-create` does), container name, user and the two host paths (spec 04). |
| `scripts-update` | Asks for the host resources path (same default), validates it exists (aborts otherwise) and runs `Sync-DevboxScripts`: copies `scripts/bash/*` to `<resources>\devbox-scripts\`, overwriting. No container involved. |
| `container-start` | Menu of **stopped** `dkdb-` containers. |
| `container-stop` | Menu of **running** `dkdb-` containers. |
| `container-delete` | Menu of **stopped** `dkdb-` containers (a running one must be stopped first); asks `[y/N]` confirmation because the container's home and installed AI client are lost; the host bind-mounted folders are not touched. |
| `container-connect` | Menu of **running** `dkdb-` containers; opens bash with `docker exec -it -u <user>`. |

- **Location:** `scripts/ps1/`.
- **Colors in `container-connect`:** it passes `-e TERM=xterm-256color -e COLORTERM=truecolor` so the default Ubuntu `.bashrc` enables the colored prompt even when `docker exec` provides a plain `xterm`.
- **Script sync (in `container-create`):** after every validation has passed, copy `scripts/bash/*` to `<resources host path>\devbox-scripts\`, overwriting existing files. Source: resolved from `$PSScriptRoot` (`scripts/ps1/` -> `scripts/bash/`). Destination: the resources path already asked and validated (default `C:\shared\devbox\resources\`). Extra files in the destination are not deleted. A message warns that manual edits to the copies are lost. Implemented as a common function `Sync-DevboxScripts`.
- All of them load the common file holding the prefix and `Select-DevboxItem`.
- `.ps1` files are ASCII with LF line endings; prompts and messages are in English.

## Consequences
- No script touches resources that do not start with `dkdb-`.
- `container-connect` does not start stopped containers: use `container-start` first.
