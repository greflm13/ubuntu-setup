#!/usr/bin/env bash

# Create keyrings folder if it does not exist
mkdir -p /usr/share/keyrings

# Mattermost public key
curl https://deb.packages.mattermost.com/pubkey.gpg -o /usr/share/keyrings/packages.mattermost.com.asc

# Mattermost repo
echo "deb [signed-by=/usr/share/keyrings/packages.mattermost.com.asc] https://deb.packages.mattermost.com stable main" > /etc/apt/sources.list.d/mattermost_stable.list

# Fortinet public key
curl https://repo.fortinet.com/repo/forticlient/7.4/ubuntu22/DEB-GPG-KEY -o /usr/share/keyrings/repo.fortinet.com.asc

# Fortinet repo
echo "deb [signed-by=/usr/share/keyrings/repo.fortinet.com.asc arch=amd64] https://repo.fortinet.com/repo/forticlient/7.4/ubuntu22/ stable non-free" > /etc/apt/sources.list.d/repo.fortinet.com.list

# Citrix Workspace
citrix_dl_urls="$(curl -sL "https://www.citrix.com/downloads/workspace-app/linux/workspace-app-for-linux-latest.html" | grep -F "_amd64.deb?__gda__" | sed -En 's|^.*rel="(//.*amd64[^"]*)".*$|\1|p')"
icaclient="https:$(echo "${citrix_dl_urls}" | grep "icaclient")"
ctxusb="https:$(echo "${citrix_dl_urls}" | grep "ctxusb")"

curl -sSL -o /tmp/icaclient_amd64.deb "${icaclient}"
curl -sSL -o /tmp/ctxusb_amd64.deb "${ctxusb}"

# WithSecure Elements
curl -sSL -o /tmp/f-secure.deb "https://download.withsecure.com/PSB/latest/f-secure-linuxsecurity.deb"

export DEBIAN_FRONTEND="noninteractive"
debconf-set-selections <<< "icaclient app_protection/install_app_protection select yes"

# Install
apt-get update

apt-get install -f /tmp/icaclient_amd64.deb -y
apt-get install -f /tmp/ctxusb_amd64.deb -y
apt-get install -f /tmp/f-secure.deb -y

apt-get install -y evolution-ews mattermost-desktop forticlient
# snap install teams-for-linux