#!/bin/sh
set -xe

if [ ! -f /etc/samba/smb.conf.ori ]; then
    mv /etc/samba/smb.conf /etc/samba/smb.conf.ori
    samba-tool domain provision \
        --domain=HMWG \
        --realm=HMWG.SAUDE.RN.GOV.BR \
        --server-role=dc \
        --dns-backend=SAMBA_INTERNAL \
        --use-rfc2307 \
        --function-level=2008_R2 \
        --adminpass=$(ADMINPASS) \
        --option="dns forwarder = 177.87.96.3 177.87.96.4"
fi

sh -c "samba -D"
exec bash
