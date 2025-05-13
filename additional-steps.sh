#!/usr/bin/env bash

# CHANGE URL TO YOUR SCRIPT HOST
SCRIPTHOST="https://raw.githubusercontent.com/greflm13/ubuntu-setup/refs/heads/main"
TO_RUN=(tpm2-keysetup 3rd-party-software)
TO_DOWNLOAD=(postinstall printer-setup)

# Download scripts
for script in "${TO_DOWNLOAD[@]}"; do
    curl -o "/root/${script}.sh" "${SCRIPTHOST}/${script}.sh"
done
cat << EOF > /root/first_boot.sh
TO_RUN=(${TO_DOWNLOAD[*]})

for script in "\${TO_DOWNLOAD[@]}"; do
    /bin/bash "/root/\${script}.sh"
    #rm /root/\${script}.sh
done
#rm /root/first_boot.sh
EOF


# Run scripts during install
for script in "${TO_RUN[@]}"; do
    curl -o "/tmp/${script}.sh" "${SCRIPTHOST}/${script}.sh"
    /bin/bash "/tmp/${script}.sh"
done
