FROM php:7.1-apache
WORKDIR /home/root
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update
RUN apt-get -y -qq install software-properties-common dialog apt-utils
RUN apt-get -y -qq install git
RUN apt-get install zip unzip
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php --version=1.10.22
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer
RUN export COMPOSER_MEMORY_LIMIT=-1
COPY ./drupal.sh /home/root
RUN rm -rf /var/www/html
RUN ln -s /var/www/web /var/www/html
WORKDIR /
CMD /bin/bash
#CMD ["apache2-foreground"]