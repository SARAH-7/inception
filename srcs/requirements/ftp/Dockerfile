FROM alpine:3.19.1

RUN apk update && apk add --no-cache vsftpd netcat-openbsd

RUN mkdir -p /var/www/html/
RUN mkdir -p /var/www/html/wordpress

ARG FTP_USER=defaultuser
ARG FTP_PASS=defaultpass

# add user for ftp server
RUN adduser -D -h /var/www/html/wordpress ${FTP_USER} && \
    echo "${FTP_USER}:${FTP_PASS}" | chpasswd


ADD conf/vsftpd.conf /etc/vsftpd/vsftpd.conf
ADD tools/run.sh /run.sh
RUN chmod +x /run.sh

# Expose the port for the ftp server
EXPOSE 21

# Expose a range of passive ports for the ftp server
EXPOSE 21100-21110


ENTRYPOINT [ "/run.sh" ]

