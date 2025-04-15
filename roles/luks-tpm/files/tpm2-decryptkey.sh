#!/bin/sh
PREREQ=""
prereqs()
 {
     echo "${PREREQ}"
 }
case $1 in
 prereqs)
     prereqs
     exit 0
     ;;
esac
. /usr/share/initramfs-tools/hook-functions
copy_exec "$(which tpm2_nvread)"
copy_exec /usr/lib/x86_64-linux-gnu/libtss2-tcti-device.so.0.0.0
copy_exec /usr/lib/x86_64-linux-gnu/libtss2-tcti-device.so.0
exit 0
