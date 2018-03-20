#!/bin/bash

source /etc/apache2/envvars
exec apache2 -D FOREGROUND
exec phpdismod xdebug
exec service apache2 reload
