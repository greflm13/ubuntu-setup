#!/usr/bin/env bash

/opt/f-secure/linuxsecurity/bin/activate --psb --subscription-key CJ2U-AGF6-AAKZ-PLLR-JAEL
yes | forticlient epctrl register anx-i-ems0401.anexia.work

gsettings set org.gnome.evolution.mail show-startup-wizard false

PASSWD=$(grep "1000" /etc/passwd)

user=$(echo "$PASSWD" | awk -F: '{print $1}')
homedir=$(echo "$PASSWD" | awk -F: '{print $6}')
gecos=$(echo "$PASSWD" | awk -F: '{print $5}')

mkdir -p "${homedir}/.config/evolution/sources"

cat << EOF > "${homedir}/.config/evolution/sources/591bae34b085e48b766838820668d737168f4a04.source"
[Data Source]
DisplayName=${user}@anexia.com
Enabled=true
Parent=f0a7e7f5a00db376e2a50d770ba037253b3d3c36

[Mail Submission]
SentFolder=folder://ac1ba36696307e7641c49b8bedf84b961343bf6c/Sent%20Items
TransportUid=3135d96bc542373cdadb0c25a8d3dbe942ccde60
RepliesToOriginFolder=false
UseSentFolder=true

[Mail Composition]
Bcc=
Cc=
DraftsFolder=folder://ac1ba36696307e7641c49b8bedf84b961343bf6c/Drafts
ReplyStyle=default
SignImip=true
TemplatesFolder=folder://local/Templates
StartBottom=inconsistent
TopSignature=inconsistent
Language=

[Mail Identity]
Address=${user}@anexia.com
Aliases=
Name=${gecos}
Organization=
ReplyTo=
SignatureUid=none

[Pretty Good Privacy (OpenPGP)]
AlwaysTrust=false
EncryptToSelf=true
KeyId=
SigningAlgorithm=
SignByDefault=false
EncryptByDefault=false
PreferInline=false
LocateKeys=true
SendPublicKey=true
SendPreferEncrypt=true
AskSendPublicKey=true

[Message Disposition Notifications]
ResponsePolicy=ask

[Secure MIME (S/MIME)]
EncryptionCertificate=
EncryptByDefault=false
EncryptToSelf=true
SigningAlgorithm=
SigningCertificate=
SignByDefault=false

[Exchange Web Services Folder]
ChangeKey=
Id=
Foreign=false
ForeignSubfolders=false
ForeignMail=
FreebusyWeeksBefore=1
FreebusyWeeksAfter=5
Name=
Public=false
UsePrimaryAddress=false
FetchGalPhotos=true
EOF

chown 1000:1000 "${homedir}/.config/evolution/sources/591bae34b085e48b766838820668d737168f4a04.source"
chmod 644 "${homedir}/.config/evolution/sources/591bae34b085e48b766838820668d737168f4a04.source"

cat << EOF > "${homedir}/.config/evolution/sources/3135d96bc542373cdadb0c25a8d3dbe942ccde60.source"
[Data Source]
DisplayName=${user}@anexia.com
Enabled=true
Parent=f0a7e7f5a00db376e2a50d770ba037253b3d3c36

[Mail Transport]
BackendName=ews

[Exchange Web Services Folder]
ChangeKey=
Id=
Foreign=false
ForeignSubfolders=false
ForeignMail=
FreebusyWeeksBefore=1
FreebusyWeeksAfter=5
Name=
Public=false
UsePrimaryAddress=false
FetchGalPhotos=true
EOF

chown 1000:1000 "${homedir}/.config/evolution/sources/3135d96bc542373cdadb0c25a8d3dbe942ccde60.source"
chmod 644 "${homedir}/.config/evolution/sources/3135d96bc542373cdadb0c25a8d3dbe942ccde60.source"

cat << EOF > "${homedir}/.config/evolution/sources/ac1ba36696307e7641c49b8bedf84b961343bf6c.source"
[Data Source]
DisplayName=${user}@anexia.com
Enabled=true
Parent=f0a7e7f5a00db376e2a50d770ba037253b3d3c36

[Mail Account]
BackendName=ews
IdentityUid=591bae34b085e48b766838820668d737168f4a04
ArchiveFolder=
NeedsInitialSetup=false
MarkSeen=inconsistent
MarkSeenTimeout=1500
Builtin=false

[Refresh]
Enabled=true
EnabledOnMeteredNetwork=true
IntervalMinutes=5

[Exchange Web Services Folder]
ChangeKey=
Id=
Foreign=false
ForeignSubfolders=false
ForeignMail=
FreebusyWeeksBefore=1
FreebusyWeeksAfter=5
Name=
Public=false
UsePrimaryAddress=false
FetchGalPhotos=true
EOF

chown 1000:1000 "${homedir}/.config/evolution/sources/ac1ba36696307e7641c49b8bedf84b961343bf6c.source"
chmod 644 "${homedir}/.config/evolution/sources/ac1ba36696307e7641c49b8bedf84b961343bf6c.source"

cat << EOF > "${homedir}/.config/evolution/sources/f0a7e7f5a00db376e2a50d770ba037253b3d3c36.source"
[Data Source]
DisplayName=${user}@anexia.com
Enabled=true
Parent=

[Authentication]
Host=exchange.anexia.work
Method=Office365
Port=443
ProxyUid=system-proxy
RememberPassword=true
User=${user}@anexia-it.com
CredentialName=
IsExternal=false

[Collection]
BackendName=ews
CalendarEnabled=true
ContactsEnabled=true
Identity=${user}@anexia-it.com
MailEnabled=true
AllowSourcesRename=true
CalendarUrl=
ContactsUrl=

[Ews Backend]
FilterInbox=true
StoreChangesInterval=3
LimitByAge=false
LimitUnit=years
LimitValue=1
CheckAll=true
ListenNotifications=true
Email=${user}@anexia.com
FilterJunk=false
FilterJunkInbox=false
GalUid=6c78acafbe0b3d800356ed752d353fcaa39335da
Hosturl=https://exchange.anexia.work/EWS/Exchange.asmx
Oaburl=https://exchange.anexia.work/OAB/44547c5c-e3bb-4b72-9509-60802f2c701c/oab.xml
OabOffline=false
OalSelected=
Timeout=120
UseImpersonation=false
ImpersonateUser=
OverrideUserAgent=false
UserAgent=Microsoft Office/14.0 (Windows NT ,5.1; Microsoft Outlook 14.0.4734; Pro)
OverrideOauth2=true
Oauth2Tenant=7d3af9b3-8682-4d5a-bec5-7af904408a6c
Oauth2ClientId=20460e5d-ce91-49af-a3a5-70b6be7486d1
Oauth2RedirectUri=https://login.microsoftonline.com/common/oauth2/nativeclient
Oauth2ResourceUri=
Oauth2EndpointHost=login.microsoftonline.com
ShowPublicFolders=false
ConcurrentConnections=1
SyncTagStamp=0
ForceHttp1=false
UseOauth2V2=true

[Security]
Method=none

[Offline]
StaySynchronized=false
EOF

chown 1000:1000 "${homedir}/.config/evolution/sources/f0a7e7f5a00db376e2a50d770ba037253b3d3c36.source"
chmod 644 "${homedir}/.config/evolution/sources/f0a7e7f5a00db376e2a50d770ba037253b3d3c36.source"