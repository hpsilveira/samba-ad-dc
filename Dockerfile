FROM debian:10.7-slim

ARG DEBIAN_FRONTEND=noninteractive

RUN echo "deb http://deb.debian.org/debian sid main" >> /etc/apt/sources.list && \
    echo "deb-src http://deb.debian.org/debian sid main" >> /etc/apt/sources.list

RUN apt-get update && \
    apt-get -y install apt-utils && \
    apt-get -y -o APT::Immediate-Configure=0 -t sid install libc6 && \
    apt-get -y install dumb-init dnsutils && \
    apt-get -y -t sid install samba samba-dsdb-modules samba-vfs-modules winbind && \
    apt-get -y autoremove && \
    apt-get autoclean && \
    apt-get clean

VOLUME ["/etc/samba", "/var/lib/samba"]

EXPOSE 	53/tcp \
	53/udp \
	88/tcp \
	88/udp \
	123/udp \
	135/tcp \
	137/udp \
	138/udp \
	139/tcp \
	389/tcp \
	389/udp \
	445/tcp \
	464/tcp \
	464/udp \
	636/tcp \
	3268/tcp \
	3269/tcp
#	49152-65535 Dynamic RPC Ports

ADD entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["dumb-init", "--"]
CMD ["entrypoint.sh"]
