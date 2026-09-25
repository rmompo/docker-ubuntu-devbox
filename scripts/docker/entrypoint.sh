#!/bin/bash
# Container entrypoint (runs as root).
# Creates the user given in DEVBOX_USER (password = user name, sudo with
# password), then hands the main process over to that user.
set -euo pipefail

if [ -z "${DEVBOX_USER:-}" ]; then
    echo "entrypoint: DEVBOX_USER is not set" >&2
    exit 1
fi

if ! id "$DEVBOX_USER" >/dev/null 2>&1; then
    useradd --create-home --shell /bin/bash --groups sudo "$DEVBOX_USER"
    echo "${DEVBOX_USER}:${DEVBOX_USER}" | chpasswd
fi

# Own the parent folder of the mounts (non-recursive: mounts are untouched).
mkdir -p "/home/${DEVBOX_USER}/devbox"
chown "${DEVBOX_USER}:${DEVBOX_USER}" "/home/${DEVBOX_USER}/devbox"

exec gosu "$DEVBOX_USER" "$@"
