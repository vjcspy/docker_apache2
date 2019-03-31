#!/bin/bash

# enable all site
for filename in /etc/apache2/sites-available/*.conf; do
    if [[ $(basename ${filename}) != "000-default.conf" ]] && [[ $(basename ${filename}) != "default-ssl.conf" ]]
     then
        a2ensite $(basename ${filename})
    fi
done

# setup debug cli
export XDEBUG_CONFIG="remote_enable=1 remote_mode=req remote_port=9000 remote_host=docker.for.mac.localhost remote_connect_back=0"
#export PHP_IDE_CONFIG="serverName=mage2"

phpdismod xdebug
service apache2 reload
