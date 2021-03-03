#!/usr/bin/env bash
set -xe

if [ -f /etc/samba/smb.conf.ori ]
then
   samba-tool domain join \
       ${DOMAIN} DC \
       --username=administrator \
       --password=${ADMINPASS} \
       --dns-backend=SAMBA_INTERNAL \
       --option="dns forwarder = ${DNS_FORWARDER}" \
       --option="idmap_ldb:use rfc2307 = yes"
else
   mv /etc/samba/smb.conf /etc/samba/smb.conf.ori
   samba-tool domain provision \
       --domain=$(echo ${DOMAIN^^} | cut -d'.' -f1) \
       --realm=${DOMAIN^^} \
       --server-role=dc \
       --dns-backend=SAMBA_INTERNAL \
       --use-rfc2307 \
       --function-level=2008_R2 \
       --adminpass=${ADMINPASS} \
       --option="dns forwarder = ${DNS_FORWARDER}"
fi

sh -c "samba -D"
exec bash
