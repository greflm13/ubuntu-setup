#!/usr/bin/env bash

PASSWD=$(grep "1000" /etc/passwd)

USER=$(echo "$PASSWD" | awk -F: '{print $1}')

usermod -aG lpadmin "$USER"

wget -O /tmp/FollowMe.zip 'https://dl.konicaminolta.eu/de/?tx_kmdownloadproxy_downloadproxy[fileId]=26a487264ae0772ba2a671e39a3edab5&tx_kmdownloadproxy_downloadproxy[documentId]=38039&tx_kmdownloadproxy_downloadproxy[system]=KonicaMinolta&type=1558521685'

cd /tmp || exit 1

unzip FollowMe.zip

mv /tmp/IT5PPDLinux_1100010000MU/German/CUPS1.2/KOC759GX.ppd /usr/share/cups/model/

sed -i 's/workgroup = WORKGROUP/workgroup = ANX.LOCAL\n   tls enabled = no/g' /etc/samba/smb.conf

lpadmin -p "FollowMe@Anexia" -D "Color Laser" -v smb://anx-i-prs01.anx.local/FollowMe -P /usr/share/cups/model/KOC759GX.ppd -o PaperSources-default=PC210 -o Model-default=C368 -o PrinterHDD-default=None
