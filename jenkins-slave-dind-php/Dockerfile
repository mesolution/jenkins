FROM mesolutions/jenkins-slave:lts

MAINTAINER TommyKs <sanakonez@live.com>

ENV DOCKER_VERSION=17.06.2
    DOCKER_COMPOSE_VERSION=1.20.0
    DOCKER_COMPOSE_MD5=80b6349a390ef3a58250f892fb0cb3c1
    CLAIR_SCANNER_VERSION=v8

ENV OS_LOCALE="en_US.UTF-8"
RUN apt-get update && apt-get install -y locales && locale-gen ${OS_LOCALE}
ENV LANG=${OS_LOCALE}
    LANGUAGE=en_US:en
    LC_ALL=${OS_LOCALE}

ENV APACHE_CONF_DIR=/etc/apache2
    PHP_CONF_DIR=/etc/php/7.1
    PHP_DATA_DIR=/var/lib/php

COPY ./app /var/www/app/
COPY entrypoint.sh /sbin/entrypoint.sh

# RUN apt-get install software-properties-common python-software-properties

# RUN	add-apt-repository ppa:git-core/ppa

# RUN	apt-get update

# RUN	apt-get install --no-install-recommends -y $buildDeps

# RUN	add-apt-repository -y ppa:ondrej/php

# RUN	add-apt-repository -y ppa:ondrej/apache2

# RUN	add-apt-repository -y ppa:certbot/certbot

RUN	apt-get update

RUN	apt-get install -y python-certbot-apache openssl wget unzip nodejs npm git nano vim curl imagemagick apache2 libapache2-mod-php7.1 libmemcached-dev php-memcached php-redis php7.1-cli php7.1-readline php7.1-mbstring php7.1-zip php7.1-intl php7.1-xml php7.1-json php7.1-curl php7.1-mcrypt php7.1-gd php7.1-pgsql php7.1-mysql php-pear php7.1-soap php7.1-intl php7.1-xdebug

RUN	apt update

RUN	apt install php7.1-bcmath

# Apache settings
RUN	cp /dev/null ${APACHE_CONF_DIR}/conf-available/other-vhosts-access-log.conf

RUN rm ${APACHE_CONF_DIR}/sites-enabled/000-default.conf ${APACHE_CONF_DIR}/sites-available/000-default.conf

RUN a2enmod rewrite php7.1
# PHP settings
RUN phpenmod mcrypt
# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --version=1.4.1 --install-dir=/usr/local/bin --filename=composer
# Cleaning
# RUN apt-get purge -y --auto-remove $buildDeps locales

RUN apt-get autoremove -y

RUN rm -rf /var/lib/apt/lists/*
# Forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/apache2/access.log

RUN ln -sf /dev/stderr /var/log/apache2/error.log

RUN chmod 755 /sbin/entrypoint.sh

RUN chown www-data:www-data ${PHP_DATA_DIR} -Rf

COPY ./configs/apache2.conf ${APACHE_CONF_DIR}/apache2.conf

COPY ./configs/app.conf ${APACHE_CONF_DIR}/sites-enabled/app.conf

COPY ./configs/php.ini  ${PHP_CONF_DIR}/apache2/conf.d/custom.ini

RUN cd /tmp

RUN curl -o ioncube.tar.gz http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz

RUN tar -xvvzf ioncube.tar.gz

RUN cp -rf ioncube/ioncube_loader_lin_7.1.so /usr/lib/php/20160303/

RUN rm -Rf ioncube.tar.gz ioncube

RUN echo "zend_extension=ioncube_loader_lin_7.1.so" > /etc/php/7.1/apache2/conf.d/00-ioncube_loader_lin_7.1.ini

WORKDIR /var/www/app/

EXPOSE 80 443

# By default, simply start apache.
CMD ["/sbin/entrypoint.sh"]
