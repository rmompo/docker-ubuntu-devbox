# 02 - Docker image

## Context
The image must be lightweight and generic: it serves any container and any AI client, so it ships with no user and no client installed.

## Reasoning
1. Stability is the goal -> Ubuntu 22.04 (LTS, considered more proven by the owner). Standard support ends in April 2027.
2. Allow a later migration -> version kept in an `ARG UBUNTU_VERSION`.
3. The user depends on the container (name, mounts) -> it is not created in the image; an entrypoint creates it at start.
4. Size -> `--no-install-recommends` and clean the apt cache.
5. This is a development machine and Python 3 is required -> include Python and `build-essential`.
6. Only generic development tools or tools useful for AI -> Node and other languages are left out.
7. Global `pip` works on 22.04, but virtual environments remain good practice -> include `python3-venv` and `pipx`.

## Decision
- **Location:** the Docker files (`Dockerfile`, entrypoint script) live in `scripts/docker/`.
- **Base:** `ubuntu:22.04` (configurable via `ARG`).
- **Base packages:** `ca-certificates`, `curl`, `wget`, `nano`, `git`, `sudo`, `gosu`, `zip`, `unzip`, `less`.
- **Recommended:** `jq`, `openssh-client`, `procps`, `bash-completion`, `gnupg`, `xz-utils`, `ripgrep`, `rsync`, `htop`, `iproute2`, `dnsutils`, `make`.
- **Python:** `python3`, `python3-pip`, `python3-venv`, `pipx`, `python-is-python3`.
- **Build tools:** `build-essential`.
- **Optional:** `tree`, `iputils-ping`.
- **Excluded:** Node and any language other than Python.
- **Environment:** `LANG=C.UTF-8`.
- **Bash colors:** adjust `/etc/skel/.bashrc` (`force_color_prompt=yes`, colored `ls` and `grep` aliases). Every new user is born with them.
- **Entrypoint (root):** if the user does not exist, create it with `useradd -m`, set its password equal to its name, add it to the `sudo` group (no `NOPASSWD`), give the user ownership of `/home/<user>/devbox` (non-recursive, so mounts are untouched) and hand the main process to that user with `gosu`. It is idempotent across restarts.
- **User:** passed via an environment variable; the password is derived from the name, so no secret travels.

## Consequences
- Docker records the container's default user as root: `docker exec` must pass `-u <user>` (done by `container-connect`).
- The image is somewhat larger because of `build-essential` (about 200 MB).
