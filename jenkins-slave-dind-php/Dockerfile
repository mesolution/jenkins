#jenkins-slave-dind-php

FROM mesolutions/jenkins-slave:lts

MAINTAINER TommyKs <sanakonez@live.com>
ENV DOCKER_VERSION=17.06.2 \
    DOCKER_COMPOSE_VERSION=1.20.0 \
    DOCKER_COMPOSE_MD5=80b6349a390ef3a58250f892fb0cb3c1 \
    CLAIR_SCANNER_VERSION=v8

RUN apt-get update && apt-get install -y locales && locale-gen "en_US.UTF-8" \
 && apt-get install -y --no-install-recommends apt-transport-https ca-certificates software-properties-common \
 && curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add - \
 && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
 && apt-get update \
 && apt-get install -y --no-install-recommends docker-ce=$DOCKER_VERSION* \
 && apt-get install openssh-server openssh-client \
 && rm -rf /var/lib/apt/lists/* \
 && curl -o /bin/docker-compose -SL https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-Linux-x86_64 \
 && echo "$DOCKER_COMPOSE_MD5  /bin/docker-compose" | md5sum -c - \
 && chmod +x /bin/docker-compose \
 && curl "https://bootstrap.pypa.io/get-pip.py" -o "/tmp/get-pip.py" \
 && python /tmp/get-pip.py \
 && pip install j2cli \
 && curl -L -o /usr/bin/clair-scanner https://github.com/arminc/clair-scanner/releases/download/$CLAIR_SCANNER_VERSION/clair-scanner_linux_amd64 \
 && chmod 777 /usr/bin/clair-scanner

COPY ini/settings.xml.j2 /tmp/settings.xml.j2
COPY scripts/scan_catalog_entry.sh docker-entrypoint-dind.sh /

ENTRYPOINT ["/docker-entrypoint-dind.sh"]
CMD ["java", "-jar", "/bin/swarm-client.jar"]

COPY ./app /var/www/app/
COPY entrypoint.sh /sbin/entrypoint.sh
RUN	wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN	echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list
RUN apt-get update -y
RUN apt-get install -y php7.1
RUN	apt-get install -y openssl
RUN	apt-get install -y wget
RUN	apt-get install -y unzip
RUN	apt-get install -y nodejs
RUN	apt-get install -y npm
RUN	apt-get install -y git
RUN	apt-get install -y nano
RUN	apt-get install -y vim
RUN	apt-get install -y curl
RUN	apt-get install -y imagemagick
RUN	apt-get install -y apache2
RUN	apt-get install -y libapache2-mod-php7.1
RUN	apt-get install -y libmemcached-dev
RUN	apt-get install -y php-memcached
RUN	apt-get install -y php-redis
RUN	apt-get install -y php7.1-cli
RUN	apt-get install -y php7.1-readline
RUN	apt-get install -y php7.1-mbstring
RUN	apt-get install -y php7.1-zip
RUN	apt-get install -y php7.1-intl
RUN	apt-get install -y php7.1-xml
RUN	apt-get install -y php7.1-json
RUN	apt-get install -y php7.1-curl
RUN	apt-get install -y php7.1-mcrypt
RUN	apt-get install -y php7.1-gd
RUN	apt-get install -y php7.1-pgsql
RUN	apt-get install -y php7.1-mysql
RUN	apt-get install -y php-pear
RUN	apt-get install -y php7.1-soap
RUN	apt-get install -y php7.1-intl
RUN	apt-get install -y php7.1-xdebug

RUN	apt update

RUN	apt install php7.1-bcmath

# Apache settings
RUN	cp /dev/null /etc/apache2/conf-available/other-vhosts-access-log.conf

RUN rm /etc/apache2/sites-enabled/000-default.conf /etc/apache2/sites-available/000-default.conf

RUN a2enmod rewrite php7.1
# PHP settings
RUN phpenmod mcrypt
# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --version=1.4.1 --install-dir=/usr/local/bin --filename=composer

RUN apt-get autoremove -y

RUN rm -rf /var/lib/apt/lists/*
# Forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/apache2/access.log

RUN ln -sf /dev/stderr /var/log/apache2/error.log

RUN chmod 755 /sbin/entrypoint.sh

RUN chown www-data:www-data /var/lib/php -Rf

COPY ./configs/apache2.conf /etc/apache2/apache2.conf

COPY ./configs/app.conf /etc/apache2/sites-enabled/app.conf

COPY ./configs/php.ini  /etc/php/7.1/apache2/conf.d/custom.ini


RUN cd /tmp && curl -o ioncube.tar.gz http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz && tar -xvvzf ioncube.tar.gz && cp -rf ioncube/ioncube_loader_lin_7.1.so /usr/lib/php/20160303/ && rm -Rf ioncube.tar.gz ioncube

RUN echo "zend_extension=ioncube_loader_lin_7.1.so" > /etc/php/7.1/apache2/conf.d/00-ioncube_loader_lin_7.1.ini

RUN service ssh start && echo "jenkins:123" | chpasswd

WORKDIR /var/www/app/

EXPOSE 80 443

# By default, simply start apache.
CMD ["/sbin/entrypoint.sh"]
