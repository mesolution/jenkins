FROM mesolutions/jenkins-slave:lts

MAINTAINER TommyKs <sanakonez@live.com>

COPY ./app /var/www/app/
COPY entrypoint.sh /sbin/entrypoint.sh

RUN	apt-get update

RUN	apt-get install -y python-certbot-apache 
