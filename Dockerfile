FROM ubuntu:14.04
MAINTAINER ryomo <ryo@the-taurus.net>

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get upgrade -y

# timezone
RUN echo 'Asia/Tokyo' > /etc/timezone
RUN dpkg-reconfigure --frontend noninteractive tzdata

# locale
RUN locale-gen ja_JP.UTF-8
RUN update-locale LANG=ja_JP.UTF-8

# apache https://help.ubuntu.com/community/ApacheMySQLPHP#Troubleshooting_Apache
RUN apt-get install -y apache2
RUN chown -R www-data:www-data /var/www/html/
RUN chmod -R 777 /var/www/html/
RUN echo 'ServerName localhost' > /etc/apache2/conf-available/fqdn.conf
RUN a2enconf fqdn

# mod_rewrite
RUN a2enmod rewrite
ADD conf/apache.conf /etc/apache2/sites-available/apache.conf
RUN a2ensite apache.conf

# ssl
RUN a2enmod ssl
RUN a2ensite default-ssl

# PHP
RUN apt-get install -y php5 php5-common php5-mcrypt curl php5-curl
ADD conf/php.ini /etc/php5/apache2/conf.d/30-myphp.ini
ADD conf/php.ini /etc/php5/cli/conf.d/30-myphp.ini

# MySQL
ENV MYSQL_ROOT_PASS='pass'
RUN echo "mysql-server mysql-server/root_password password $MYSQL_ROOT_PASS" | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password $MYSQL_ROOT_PASS" | debconf-set-selections
RUN apt-get install -y mysql-server php5-mysql
ADD conf/mysql.cnf /etc/mysql/conf.d/mysql.cnf

# phpMyAdmin
RUN echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
RUN echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
RUN echo "phpmyadmin phpmyadmin/mysql/admin-pass password $MYSQL_ROOT_PASS" | debconf-set-selections
RUN echo "phpmyadmin phpmyadmin/mysql/app-pass password" | debconf-set-selections
RUN apt-get install -y phpmyadmin

# Phalcon
RUN apt-get install -y software-properties-common
RUN apt-add-repository ppa:phalcon/stable
RUN apt-get update
RUN apt-get install -y php5-phalcon

# etc
RUN apt-get install -y nano

# auto security update
RUN cp /usr/share/unattended-upgrades/20auto-upgrades /etc/apt/apt.conf.d/20auto-upgrades

# Supervisor
RUN apt-get install -y supervisor
COPY conf/supervisord_docker.conf /etc/supervisor/conf.d/supervisord.conf

# http://stackoverflow.com/questions/27826241/running-nano-in-docker-container
ENV TERM=xterm

CMD ["/usr/bin/supervisord"]

EXPOSE 80 443
