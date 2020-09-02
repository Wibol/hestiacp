#!/bin/sh

# Hestia Control Panel upgrade script for target version 1.3.0

#######################################################################################
#######                      Place additional commands below.                   #######
#######################################################################################

# Add NPM to the default writeable folder list
echo "[ * ] Updating default writable folders for all users..."
for user in $($HESTIA/bin/v-list-sys-users plain); do
    mkdir -p \
        $HOMEDIR/$user/.npm

    chown $user:$user \
        $HOMEDIR/$user/.npm
done

# Add default SSL Certificate config when ip is visited
if [ "$PROXY_SYSTEM" = "nginx" ]; then
    echo "[ ! ] Update IP.conf"
    while read IP; do
        rm /etc/nginx/conf.d/$IP.conf
        cat $WEBTPL/$PROXY_SYSTEM/proxy_ip.tpl |\
        sed -e "s/%ip%/$IP/g" \
            -e "s/%web_port%/$WEB_PORT/g" \
            -e "s/%proxy_port%/$PROXY_PORT/g" \
            -e "s/%proxy_ssl_port%/$PROXY_SSL_PORT/g" \
        > /etc/$PROXY_SYSTEM/conf.d/$IP.conf
    done < <(ls $HESTIA/data/ips/)
fi
