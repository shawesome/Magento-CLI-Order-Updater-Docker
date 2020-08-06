#!/bin/bash

# Wait until the mysql container is ready to receive connections
while ! mysqladmin ping -umagento -pmagento -hmysql --silent; do
    sleep 1
done

chmod +x /opt/magento/bin/magento

/opt/magento/bin/magento setup:install \
  --db-host=mysql \
  --db-name=magento \
  --db-user=magento \
  --db-password=magento \
  --base-url=http://martin.local \
  --admin-firstname=Martin \
  --admin-lastname=Shaw \
  --admin-email=mshaw1989@gmail.com \
  --admin-user=admin \
  --admin-password=admin123 \
  --language=en_US \
  --currency=USD \
  --timezone=UTC \
  --use-rewrites=0 \
  --elasticsearch-host=elasticsearch

# Get rid of 2fa, it's annoying for a dev environment.
bin/magento module:disable Magento_TwoFactorAuth

# Install sample data so we have some things to work with.
bin/magento sampledata:deploy

# Call Magento's setup commands to get sampledata and our module registered
bin/magento setup:upgrade
bin/magento setup:di:compile

echo "Launching nginx and php.."
/etc/init.d/php7.3-fpm start
nginx -g "daemon off;"
