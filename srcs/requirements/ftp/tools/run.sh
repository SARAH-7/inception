#!/bin/sh


# ==============================
# Wait for WordPress's PHP-FPM
# ==============================
while ! nc -z wordpress 9000; do   
  sleep 2
  echo "Waiting for WordPress's PHP-FPM to be ready..."
done
echo "WordPress's PHP-FPM is ready."


# ================================
# Adjust Permissions for FTP User
# ================================
chown -R "${FTP_USER}:${FTP_USER}" /var/www/html/wordpress
chmod -R 755 /var/www/html/wordpress



# ==============================
# Start VSFTPD
# ==============================
echo "Starting VSFTPD..."
exec /usr/sbin/vsftpd /etc/vsftpd/vsftpd.conf