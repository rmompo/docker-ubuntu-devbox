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
| `container-start` | Menu of **stopped** `dkdb-` containers. |
| `container-stop` | Menu of **running** `dkdb-` containers. |
| `container-connect` | Menu of **running** `dkdb-` containers; opens bash with `docker exec -it -u <user>`. |

- All of them load the common file holding the prefix and `Select-DevboxItem`.
- `.ps1` files are ASCII with LF line endings; prompts and messages are in English.

## Consequences
- No script touches resources that do not start with `dkdb-`.
- `container-connect` does not start stopped containers: use `container-start` first.
