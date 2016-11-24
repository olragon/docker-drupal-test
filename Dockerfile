FROM ubuntu:latest

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Nginx
RUN apt-get update && apt-get install -y nginx
ADD conf/nginx/conf.d /etc/nginx/sites-enabled
RUN service nginx restart

# PHP 7
RUN apt-get update && apt-get install -y php7.0-fpm php7.0-curl php7.0-gd php7.0-json php7.0-mbstring php7.0-mcrypt php7.0-mysql php7.0-opcache php7.0-xml php7.0-zip

# Drush
RUN cd /usr/local/bin && php -r "readfile('https://s3.amazonaws.com/files.drush.org/drush.phar');" > drush && chmod +x drush && drush -y init

# Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && php -r "if (hash_file('SHA384', 'composer-setup.php') === 'aa96f26c2b67226a324c27919f1eb05f21c248b987e6195cad9690d5c1ff713d53020a02ac8c217dbf90a7eacc9d141d') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && php composer-setup.php && php -r "unlink('composer-setup.php');" && chmod +x composer.phar && mv composer.phar /usr/local/bin/composer

RUN apt-get install -y git-core vim curl mysql-client

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#ENTRYPOINT service php7.0-fpm start && service nginx start

EXPOSE 80
