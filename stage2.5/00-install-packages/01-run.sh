#!/bin/bash -e

HASH=`wget https://api.github.com/repos/samyk/poisontap/git/refs/heads/master -qO -| grep \"sha\" | cut -f 2 -d ':' | cut -f 2 -d \"`

if [ ! -d files ]; then
    mkdir files
fi

if [ -f files/poisontap.hash ]; then
    HASH_LOCAL=`cat files/poisontap.hash`
fi

if [ ! -e "files/poisontap.zip" ] || [ "$HASH" != "$HASH_LOCAL"  ]; then
    wget "https://github.com/samyk/poisontap/archive/master.zip" -O files/poisontap.zip
    echo $HASH > "files/poisontap.hash"
fi

unzip files/poisontap.zip -x "poisontap-master/backend_server.js" -d files/
mv files/poisontap-master files/poisontap
if [ -n "${POISONTAP_ENDPOINT}" ]; then
    sed -i "s/YOUR.DOMAIN:1337/${POISONTAP_ENDPOINT}/g" files/poisontap/backdoor.html
fi
rsync -a --chown=1000:1000 files/poisontap ${ROOTFS_DIR}/home/pi/
install -m 644 files/poisontap/dhcpd.conf ${ROOTFS_DIR}/etc/dhcp/dhcpd.conf

on_chroot << EOF
chown -R pi /home/pi/poisontap
EOF
