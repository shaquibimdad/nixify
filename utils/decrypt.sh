#!/bin/bash

echo
read -s -p "Enter Decryption Password: " passwd
echo
read -s -p "Enter Password: " mpasswd
echo

mkdir -p temp && cp -r encrypted/* temp && cd temp && mkdir -p decrypted
for file in *.gpg; do
    echo "$passwd" | gpg --batch --yes --passphrase-fd 0 --output "decrypted/${file%.gpg}" --decrypt "$file"
done
cd decrypted

for file in *.zip; do
    unzip -P "$zippasswd" "$file"
done
rm -f *.zip

echo "$gpgpasswd" | gpg --batch --import-options restore --import exported_gpg_key.gpg
rm -f exported_gpg_key.gpg

mkdir -p ~/.ssh && cp -fr * ~/.ssh
chmod 600 ~/.ssh/*
cd ../.. && rm -rf temp