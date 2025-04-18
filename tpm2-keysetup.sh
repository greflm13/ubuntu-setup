#!/usr/bin/env bash

KEYSIZE=64
TEMPKEY="tempkey"
KEYAREA="0x1500016"
KERNEL=$(readlink /boot/initrd.img | sed 's/initrd.img-//')
HOSTNAME=$(cat /etc/hostname)
CRYPTDEVNAME=$(grep -o '^\s*[^#[:space:]]\S*' /etc/crypttab)
CRYPTDEVPATH=$(cryptsetup status "${CRYPTDEVNAME}" | sed -n -E 's/\s+device:\s+(.*)/\1/p')

# Generate a $KEYSIZE long char alphanumeric key and save it to /root/${HOSTNAME}_luks.key
KEY=$(tr -dc 'a-zA-Z0-9' < /dev/urandom 2>/dev/null | head -c ${KEYSIZE})

# Store the key in /root/${HOSTNAME}_luks.key
echo -n "$KEY" > "/root/${HOSTNAME}_luks.key"

# Clear out the area on the TPM2 just to be safe
tpm2_nvundefine ${KEYAREA} 2>/dev/null

# Define the area for the key on the TPM2
tpm2_nvdefine -s ${KEYSIZE} ${KEYAREA} >/dev/null

# Store the key in the TPM
tpm2_nvwrite -i "/root/${HOSTNAME}_luks.key" ${KEYAREA}

# Add key to encrypted partition
echo "${TEMPKEY}" | cryptsetup luksAddKey "${CRYPTDEVPATH}" "/root/${HOSTNAME}_luks.key"

# Creating a key recovery script and putting it at /usr/local/sbin/tpm2-getkey...
cat << EOF > /usr/local/sbin/tpm2-getkey
#!/bin/sh
if [ "\${CRYPTTAB_NAME}" != "" ]
then
   TMP_FILE=".tpm2-getkey.\${CRYPTTAB_NAME}.tmp"

   if [ -f "\${TMP_FILE}" ]
   then
      # tmp file exists, meaning we tried the TPM2 this boot, but it didn't work for the drive and this must be the second
      # or later try to unlock the drive. Either the TPM2 is failed/missing, or has the wrong key stored in it.
      /lib/cryptsetup/askpass "Automatic disk unlock via tpm2-getkey failed for (\${CRYPTTAB_SOURCE}) Enter passphrase: "
      exit
   fi

   # No tmp, so it is the first time trying the script. Create a tmp file and try the TPM
   touch \${TMP_FILE}
   tpm2_nvread -s ${KEYSIZE} ${KEYAREA}
else
   echo \$(tpm2_nvread -s ${KEYSIZE} ${KEYAREA})
fi

EOF

# Set the file ownership and permissions
chown root: /usr/local/sbin/tpm2-getkey
chmod 750 /usr/local/sbin/tpm2-getkey

# Creating initramfs hook and putting it at /etc/initramfs-tools/hooks/tpm2-decryptkey
cat << EOF > /etc/initramfs-tools/hooks/tpm2-decryptkey
#!/bin/sh
PREREQ=""
prereqs()
 {
     echo "\${PREREQ}"
 }
case \$1 in
 prereqs)
     prereqs
     exit 0
     ;;
esac
. /usr/share/initramfs-tools/hook-functions
copy_exec \$(which tpm2_nvread)
copy_exec /usr/lib/x86_64-linux-gnu/libtss2-tcti-device.so.0.0.0
copy_exec /usr/lib/x86_64-linux-gnu/libtss2-tcti-device.so.0
exit 0
EOF

# Set the file ownership and permissions

chown root: /etc/initramfs-tools/hooks/tpm2-decryptkey
chmod 755 /etc/initramfs-tools/hooks/tpm2-decryptkey

cp /etc/crypttab /etc/crypttab.bak

# Check to see if tpm2-getkey has already been added to the device manually or by a previous version
if ! grep -q "^\s*${CRYPTDEVNAME}.*tpm2-getkey" /etc/crypttab
then
    # grep did not find the keyscript on the line for the device, need to add it.
    # the initramfs parameter is also added so it will be unlocked before systemd
    # because systemd does not directly support keyscripts so secondary drives
    # won't unlock.
    sed -i "s%\(^\s*${CRYPTDEVNAME}.*\)$%\1,initramfs,keyscript=/usr/local/sbin/tpm2-getkey%" /etc/crypttab
fi

# e.g. this line: sda3_crypt UUID=d4a5a9a4-a2da-4c2e-a24c-1c1f764a66d2 none luks
# should become : sda3_crypt UUID=d4a5a9a4-a2da-4c2e-a24c-1c1f764a66d2 none luks,initramfs,keyscript=/usr/local/sbin/tpm2-getkey

if ! [ -f "/boot/initrd.img-${KERNEL}.orig" ]
then
   # Backup up initramfs to /boot/initrd.img-${KERNEL}.orig
   cp "/boot/initrd.img-${KERNEL}" "/boot/initrd.img-${KERNEL}.orig"
fi

# Update initramfs to support automatic unlocking from the TPM2
mkinitramfs -o "/boot/initrd.img-${KERNEL}" "${KERNEL}"

# Remove tempkey from LUKS
echo "${TEMPKEY}" | sudo cryptsetup luksRemoveKey "${CRYPTDEVPATH}"

# Export LUKS header for backup
cryptsetup luksHeaderBackup "${CRYPTDEVPATH}" --header-backup-file "/root/${HOSTNAME}_luks.header.bin"