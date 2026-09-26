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

user_home="/home/${DEVBOX_USER}"

# Docker creates the mount target folders (and so the home) before this
# script runs, and useradd then skips copying /etc/skel. Copy any missing
# skel file (no overwrite) so .bashrc and its colors are always present.
cp -rn /etc/skel/. "$user_home/" || true
chown "${DEVBOX_USER}:${DEVBOX_USER}" "$user_home"
for entry in $(ls -A /etc/skel); do
    chown -R "${DEVBOX_USER}:${DEVBOX_USER}" "${user_home}/${entry}"
done

# Own the parent folder of the mounts (non-recursive: mounts are untouched).
mkdir -p "${user_home}/devbox"
chown "${DEVBOX_USER}:${DEVBOX_USER}" "${user_home}/devbox"

exec gosu "$DEVBOX_USER" "$@"
