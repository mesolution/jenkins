# jenkins-slave-dind-php
FROM mesolutions/jenkins-slave:lts

MAINTAINER TommyKs <sanakonez@live.com>

COPY ./app /var/www/app/
COPY entrypoint.sh /sbin/entrypoint.sh

RUN	apt-get update

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
RUN	apt-get install -y libmemcached-dev
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
