FROM ubuntu:latest

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Nginx
RUN apt-get update && apt-get install -y nginx git-core vim curl mysql-client
ADD conf/nginx/conf.d /etc/nginx/sites-enabled
RUN service nginx restart

# PHP 7
RUN apt-get update && apt-get install -y php7.0-fpm php7.0-curl php7.0-gd php7.0-json php7.0-mbstring php7.0-mcrypt php7.0-mysql php7.0-opcache php7.0-xml php7.0-zip

# Drush
RUN cd /usr/local/bin && php -r "readfile('https://github.com/drush-ops/drush/releases/download/8.1.16/drush.phar');" > drush && chmod +x drush && drush -y init

# Composer
RUN cd /usr/local/bin && php -r "readfile('https://github.com/composer/composer/releases/download/1.6.3/composer.phar');" > composer && chmod +X composer

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 80
