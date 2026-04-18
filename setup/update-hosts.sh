#!/bin/sh
set -eu

HOSTS_FILE=/etc/hosts
BACKUP="/etc/hosts.bak.$(date +%Y%m%d%H%M%S)"
TMPFILE=$(mktemp)

sudo cp "$HOSTS_FILE" "$BACKUP"

grep -vE '(^|\s)(gx10-7fec|gx10-7fec\.local|gx10|gx10\.local|pgx-1b13|pgx-1b13\.local|pgx|pgx\.local)(\s|$)' "$HOSTS_FILE" > "$TMPFILE"
cat <<'EOF' >> "$TMPFILE"
192.168.178.11 gx10-7fec gx10-7fec.local gx10 gx10.local
192.168.178.13 pgx-1b13 pgx pgx-1b13.local pgx.local
EOF

sudo cp "$TMPFILE" "$HOSTS_FILE"
rm -f "$TMPFILE"

echo "Updated $HOSTS_FILE"
echo "Backup saved to $BACKUP"
