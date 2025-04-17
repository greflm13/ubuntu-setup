#!/usr/bin/env bash

# Create keyrings folder if it does not exist
mkdir -p /etc/apt/keyrings

# Mattermost public key
curl https://deb.packages.mattermost.com/pubkey.gpg -o /etc/apt/keyrings/packages.mattermost.com.asc

# Mattermost repo
echo "deb [signed-by=/etc/apt/keyrings/packages.mattermost.com.asc] https://deb.packages.mattermost.com stable main" > /etc/apt/sources.list.d/mattermost_stable.list

# Anexia Fortimirror public key
curl https://fortimirror.anexia.com/stable/DEB-GPG-KEY -o /etc/apt/keyrings/fortimirror.anexia.com.asc

# Anexia Fortimirror repo
echo "deb [signed-by=/etc/apt/keyrings/fortimirror.anexia.com.asc arch=amd64] https://fortimirror.anexia.com/stable stable non-free" > /etc/apt/sources.list.d/fortimirror.anexia.list

apt-get update

# Citrix Workspace
export DEBIAN_FRONTEND="noninteractive"
citrix_dl_urls="$(curl -sL "https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html" | grep -F "_amd64.deb?__gda__" | sed -En 's|^.*rel="(//.*amd64[^"]*)".*$|\1|p')"
icaclient="https:$(echo "${citrix_dl_urls}" | grep "icaclient")"
ctxusb="https:$(echo "${citrix_dl_urls}" | grep "ctxusb")"

curl -sSL -o /tmp/icaclient_amd64.deb "${icaclient}"
curl -sSL -o /tmp/ctxusb_amd64.deb "${ctxusb}"

debconf-set-selections <<< "icaclient app_protection/install_app_protection select yes"

apt-get install -f /tmp/icaclient_amd64.deb -y
apt-get install -f /tmp/ctxusb_amd64.deb -y

# WithSecure Elements
curl -sSL -o /tmp/f-secure.deb "https://download.withsecure.com/PSB/latest/f-secure-linuxsecurity.deb"

apt-get install -f /tmp/f-secure.deb

# @TODO
# move to first boot
# /opt/f-secure/linuxsecurity/bin/activate --psb --subscription-key CJ2U-AGF6-AAKZ-PLLR-JAEL

apt-get install -y evolution-ews mattermost-desktop forticlient

