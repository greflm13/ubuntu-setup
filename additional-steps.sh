#!/usr/bin/env bash

# CHANGE URL TO YOUR SCRIPT HOST
SCRIPTHOST="https://raw.githubusercontent.com/greflm13/ubuntu-setup/refs/heads/main"
TO_RUN=(tpm2-keysetup 3rd-party-software)
TO_DOWNLOAD=(postinstall)

# Download scripts
for script in "${TO_DOWNLOAD[@]}"; do
    curl -o "/root/${script}.sh" "${SCRIPTHOST}/${script}.sh"
done

# Run scripts during install
for script in "${TO_RUN[@]}"; do
    curl -o "/tmp/${script}.sh" "${SCRIPTHOST}/${script}.sh"
    /bin/bash "/tmp/${script}.sh"
done
