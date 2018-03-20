# docker-ubuntu16-apache2-php7
A docker image based on Ubuntu 16.04 with Apache2 + PHP 7.0

## Pull the image

Pull the latest stable version from the [Docker Hub Registry]


## Run

After building the image, run the container.
```
docker run --name apache2-php7 -v ~/path/to/code:/var/www -d -p [host-port]:80 francarmona/docker-ubuntu16-apache2-php7
```
Browse to [http://localhost:[host-port]](http://localhost:[host-port]) to view your app.

## Use as a base image

Some cases will be necessary to create a new image using this one as the base, for example to overwrite configuration files.

Create a Dockerfile with following content and then build the image.

```Dockerfile
FROM francarmona/docker-ubuntu16-apache2-php7

MAINTAINER Khoi Le <mr.vjcspy@gmail.com>

# Apache site conf
ADD config/apache/apache-virtual-hosts.conf /etc/apache2/sites-enabled/000-default.conf
ADD config/apache/apache2.conf /etc/apache2/apache2.conf
```

## Packages included

 *php7.0-* (fully suport magento2)
 * curl
 * libapacha2-mod-php
 * apt-transport-https
 * nano
 * lynx-cur
 * composer

## Exposed ports

80

## Exposed volumes

 - webroot: `/var/www`

## Xdebug Configuration
```
# php.ini
xdebug.default_enable=1
xdebug.remote_enable=1
xdebug.remote_handler=dbgp
; port 9000 is used by php-fpm
xdebug.remote_port=9000
xdebug.remote_autostart=1
; no need for remote host
xdebug.remote_connect_back=1
xdebug.idekey="PHPSTORM"
```


It should work fine on Linux boxes, but I found some issues trying to run it in Mac OS. I will show you some changes I tried that worked on both OS.

After some tries likes ssh bridge networks, config for remote connect back but all are not work I found a nice trick, I recommend, add an alias to our interface with static IP.

In Mac:

sudo ifconfig en0 alias 10.254.254.254 255.255.255.0
In Linux:

sudo ip addr add 10.254.254.254/24 brd + dev eth0 label eth0:1

Now in order to use this new static IP, we need to add this two new lines in our xdebug.ini:

```
xdebug.profiler_enable=0
xdebug.remote_host=10.254.254.254
```

## Demo docker-compose.yml file
```
# docker-compose.yml

  version: "2"

  services:

      webserver:
          image: vjcspy/docker-apache2
          links:
              - mysql
          expose:
              - "9000"
          ports:
              - "80:80"
#              - "8999:9000"
          networks:
              - back-tier
          volumes:
              - /Users/vjcspy/sites:/var/www
              - ./docker-data/site-available/mage22.local.conf:/etc/apache2/sites-available/mage22.local.conf
          environment:
              - ALLOW_OVERRIDE=true
          hostname: webserver
#          cpu_shares: 512             # 0.5 CPU
#          mem_limit: 536870912        # 512 MB RAM

      mysql:
          image: mysql
          ports:
              - "3306:3306"
          networks:
              - back-tier
          volumes:
              - ./docker-data/mysql-data/:/var/lib/mysql/
          environment:
              - MYSQL_ROOT_PASSWORD=root
          hostname: mysql
#          cpu_shares: 512             # 0.5 CPU
#          mem_limit: 536870912        # 512 MB RAM

  networks:
      back-tier:
```
 
## Out of the box

 * Ubuntu 16.04 LTS
 * Apache2
 * PHP7
 * Composer

