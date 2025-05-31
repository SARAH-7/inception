#!/bin/bash
set -e

# Print all executed commands (optional, for debugging)
set -x

# Ensure FTP_USER and FTP_PASS are set
if [ -z "$FTP_USER" ] || [ -z "$FTP_PASS" ]; then
  echo "FTP_USER or FTP_PASS is not set. Exiting."
  exit 1
fi

# Create the user if it doesn't exist
if ! id "$FTP_USER" &>/dev/null; then
  useradd -m "$FTP_USER"
  echo "$FTP_USER:$FTP_PASS" | chpasswd
  usermod -d /var/www/html/wordpress "$FTP_USER"
fi

# Run vsftpd
exec /usr/sbin/vsftpd /etc/vsftpd.conf
