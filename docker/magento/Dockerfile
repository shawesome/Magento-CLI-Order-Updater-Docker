FROM debian:stretch

# Configure locales and install some basic packages
RUN apt-get update -q \
    && apt-get install -y -q --no-install-recommends --no-install-suggests apt-utils \
    git \
    openssh-client \
    locales \
    curl \
    ca-certificates \
    apt-transport-https \
    lsb-release \
    gnupg \
    dirmngr \
    procps \
    mysql-client \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG=en_US.utf8

# Add dotdeb repository for nginx and php
RUN echo "deb http://packages.dotdeb.org stretch all\ndeb-src http://packages.dotdeb.org stretch all" > /etc/apt/sources.list.d/dotdeb.list \
  && curl -s https://www.dotdeb.org/dotdeb.gpg -o dotdeb.gpg \
  && apt-key add dotdeb.gpg \
  && rm dotdeb.gpg
RUN curl -Ls https://packages.sury.org/php/apt.gpg -o /etc/apt/trusted.gpg.d/php.gpg
RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

# Install a bunch of packages that Magento2 needs
RUN apt-get update && apt-get install -y -q --no-install-recommends --no-install-suggests \
    php7.3-bcmath \
    php7.3-cli \
    php7.3-common \
    php7.3-curl \
    php7.3-fpm \
    php7.3-gd \
    php7.3-igbinary \
    php7.3-imap \
    php7.3-intl \
    php7.3-json \
    php7.3-mbstring \
    php7.3-mysql \
    php7.3-opcache \
    php7.3-readline \
    php7.3-redis \
    php7.3-soap \
    php7.3-xml \
    php7.3-zip \
    php-imagick \
    php7.3-dev \
    build-essential \
    php-pear \
    nginx \
    unzip

# Do some tidying up of the package manager.
RUN apt-get autoremove -y \
  && apt-get autoclean -y \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# Install composer
RUN curl -s https://getcomposer.org/installer | php \
  && mv /composer.phar /usr/local/bin/composer

# Configure composer so that it is authorised to install Magento (NOTE! Needs a valid auth.json file in conf/auth.json)
COPY ./conf/auth.json /root/.composer/auth.json

# Install the Magento2 files.
RUN mkdir /opt/magento
WORKDIR /opt/magento
RUN composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition .

# Copy in our auth.json so we can run sampledata deployment
COPY ./conf/auth.json /opt/magento/var/composer_home/auth.json

# Setup permissions
RUN find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +
RUN find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +
RUN chown -R :www-data .
RUN chmod u+x bin/magento

# Grab some nginx configuration
COPY ./conf/magento.conf /etc/nginx/conf.d/
# Pull over a script which does the rest of the installation
COPY ./docker-entrypoint.sh /opt/magento/docker-entrypoint.sh
RUN chmod +x /opt/magento/docker-entrypoint.sh

ENTRYPOINT ["/opt/magento/docker-entrypoint.sh"]

