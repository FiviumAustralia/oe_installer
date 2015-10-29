#!/bin/bash

# Terminate on nay failed commands
set -e


# Verify we are running as root

FILE="/tmp/out.$$"
GREP="/bin/grep"
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi


# Verify we are on the Ubuntu VM

hostname=`uname -n`
if [[ $hostname != "vagrant-ubuntu-trusty-64" ]]; then
  echo You must run this script on the virtual box
  exit 1
fi


# Get behat

cd /vagrant/install
rm -rf /var/www/behat
git clone git://github.com/Behat/Behat.git /var/www/behat 
cd /var/www/behat

cp /vagrant/install/composer.json /var/www/behat/
cp /vagrant/install/behat.yml /var/www/behat/


# symlink directories

cd /var/www/behat
rm -rf features
mkdir -p vendor/yiisoft
ln -s /var/www/openeyes/features features
ln -s /var/www/openeyes/protected/yii vendor/yiisoft/yii
ln -s /var/www/openeyes/protected protected


# run composer to get behat dependencies

curl https://getcomposer.org/composer.phar -o composer.phar
chmod +x composer.phar
mv composer.phar /usr/bin/composer
composer install


# download chrome and firefox

apt-get install -f
apt-get install -y xorg jwm firefox
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i --force-depends google-chrome-stable_current_amd64.deb


# Get the latest chromedriver for linux chrome

cd /var/www/behat
LATEST=$(wget -q -O - http://chromedriver.storage.googleapis.com/LATEST_RELEASE)
wget http://chromedriver.storage.googleapis.com/$LATEST/chromedriver_linux64.zip
unzip chromedriver_linux64.zip && rm chromedriver_linux64.zip
cp chromedriver /usr/bin/


# Download selenium standalone server 2.48.2

wget http://selenium-release.storage.googleapis.com/2.48/selenium-server-standalone-2.48.2.jar
cp /vagrant/install/start-selenium-server.sh /var/www/behat


# Link JWM window manager to X
echo "exec /usr/bin/jwm" > /home/vagrant/.xsession

