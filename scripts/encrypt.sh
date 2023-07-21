#!/bin/bash

read -s -p "Enter passphrase: " passphrase
echo

for file in *; do
  gpg --batch --yes --cipher-algo AES256 --passphrase "$passphrase" -c "$file"; 
done
