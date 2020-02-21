FROM ubuntu:18.04
LABEL maintainer="sarath"
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
  && apt-get install -y gnupg tzdata \
  && echo "UTC" > /etc/timezone \
  && dpkg-reconfigure -f noninteractive tzdata
COPY --chown=www-data:www-data . /srv/app
WORKDIR /srv/app
RUN apt-get update \
  && apt-get install -y curl zip unzip git supervisor \
    apache2 libapache2-mod-php7.2 php7.2-cli \
    php7.2-pgsql php7.2-gd \
    php7.2-curl php7.2-memcached \
    php7.2-imap php7.2-mysql php7.2-mbstring \
    php7.2-xml php7.2-zip php7.2-bcmath php7.2-soap \
    php7.2-intl php7.2-readline php7.2-xdebug \
    php-msgpack php-igbinary \
  && php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
  && mkdir /run/php \
  && apt-get -y autoremove \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD vhosts.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite
RUN service apache2 restart
CMD ["/usr/sbin/apachectl", "-D", "FOREGROUND"]
EXPOSE 80
