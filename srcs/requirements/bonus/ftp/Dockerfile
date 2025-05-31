FROM debian:bullseye

# Install vsftpd
RUN apt update && apt install -y vsftpd

# Copy configuration file
COPY ./conf/vsftpd.conf /etc/vsftpd.conf

# Copy the entrypoint script and make it executable
COPY ./tools/docker-entry.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Expose FTP ports
EXPOSE 20 21 30000-30009

# Use the custom entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
