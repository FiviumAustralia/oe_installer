#!/bin/bash

## Reset various config files

# Test command parameters
compile=1
resartserv=1
clearcahes=1
buildassests=1
migrate=1
showhelp=0
composer=1
nowarnmigrate=0

for i in "$@"
do
case $i in
	--no-compile) compile=0
	;;
	--no-restart) resartserv=0
	;;
	--no-clear) clearcahes=0
	;;
	--no-assets) buildassests=0
	;;
    --no-migrate|--nomigrate) migrate=0
	;;
    --help) showhelp=1
    ;;
	--no-composer) composer=0
	;;
	--no-warn-migrate) nowarnmigrate=1
	;;
	*)  echo "Unknown command line: $i"
    ;;
esac
done

# Show help text
if [ $showhelp = 1 ]; then
    echo ""
    echo "DESCRIPTION:"
    echo "Applies various fixes to make sure files in in the correct place, database is migrated, code is compiled, etc."
    echo ""
    echo "usage: $0 <branch> [--help] [--no-compile] [--no-restart] [--no-clear ] [--no-assets] [--no-migrate]"
    echo ""
    echo "COMMAND OPTIONS:"
	echo ""
	echo "  --help         : Show this help"
    echo "  --no-compile   : Do not complile java modules"
	echo "  --no-restart   : Do not restart services"
	echo "  --no-clear     : Do not clear caches"
	echo "  --no-assets    : Do not (re)build assets"
    echo "  --no-migrate   : Do not run db migrations"
	echo "  --no-composer  : Do not update composer dependencies"
	echo ""
    exit 1
fi

source /etc/openeyes/env.conf

## Update tools
bash /vagrant/install/update-oe-tools.sh

cd /var/www/openeyes
if [ -f ".htaccess.sample" ]; then
echo Renaming .htaccess file
sudo mv .htaccess.sample .htaccess
if [ ! "$env" = "VAGRANT" ]; then chown -R www-data:www-data .htaccess; fi
fi

if [ -f "index.example.php" ]; then
echo Renaming index.php file
sudo mv index.example.php index.php
if [ ! "$env" = "VAGRANT" ]; then chown -R www-data:www-data index.php; fi
fi

if [ ! -d "protected/config/local" ]; then
	echo "WARNING: this code branch uses db settings from common.php, not /etc/openeyes"
	sudo mv protected/config/local.sample protected/config/local
	sudo mv protected/config/local/common.sample.php protected/config/local/common.php
	if [ ! "$envtype" = "VAGRANT" ]; then sudo chown -R www-data:www-data protected/config/local; fi
	sudo chmod -R 775 protected/config/local
	# When using old oe versions, overwirte password in commpon.php to use new default usermname/password
	sudo sed -i "s/'username' => 'root',/'username' => 'openeyes',/" /var/www/openeyes/protected/config/local/common.php
	sudo sed -i "s/'password' => '',/'password' => 'openeyes',/" /var/www/openeyes/protected/config/local/common.php
fi;

if [ ! -f "protected/config/local/common.php" ]; then
    if [ -d "/etc/openeyes/backup/config/" ]; then
        echo "*********** WARNING: Restoring backed up local configuration ... ***********"
        sudo cp -R /etc/openeyes/backup/config/local/* protected/config/local/.
    else
        echo "WARNING: Copying sample configuration into local ..."
        #sudo cp -R protected/config/local.sample/* protected/config/local/.
		sudo mkdir -p protected/config/local
		sudo cp -n /var/www/openeyes/protected/config/local.sample/common.sample.php /var/www/openeyes/protected/config/local/common.php
		sudo cp -n /var/www/openeyes/protected/config/local.sample/console.sample.php /var/www/openeyes/protected/config/local/console.php

    fi;
fi;

# Make sure yii framework found/linked
#  ******* Retired since v1.17, now using composer - following block can be removed if no errors are found
# sudo rm "/var/www/openeyes/vendor/yiisoft/yii" 2>/dev/null || :
# sudo mkdir -p /var/www/openeyes/vendor/yiisoft
# if [ ! "$envtype" = "VAGRANT" ]; then sudo chown -R www-data:www-data /var/www/openeyes/vendor; fi
#
# if [ -d "/usr/lib/openeyes/yii" ]; then
# 	# v1.12+
# 	echo "Linking Yii framework to /usr/lib/openeyes/yii"
# 	sudo ln -s /usr/lib/openeyes/yii /var/www/openeyes/vendor/yiisoft/yii
# else
# 	#fix for pre v1.12
# 	echo "Linking Yii framework to /var/www/openeyes/protected/yii"
# 	sudo ln -s /var/www/openeyes/protected/yii /var/www/openeyes/vendor/yiisoft/yii
# fi



# Make sure vendor directory found/linked
if [ ! -d "/var/www/openeyes/protected/vendors" ]; then
	echo Linking vendor framework
	sudo ln -s /usr/lib/openeyes/vendors /var/www/openeyes/protected/vendors
	sudo chown -R www-data:www-data /var/www/openeyes/protected/vendors 2>/dev/null || :
	if [ ! $? = 0 ]; then echo "unable to link vendors - this is expected for versions prior to v1.12"; fi
fi

# update composer and npm dependencies
if [ $composer == 1 ]; then
	if [ "$env" = "LIVE" ]; then
		echo "Installing/updating composer dependencies for LIVE"
		sudo composer install --no-dev --no-plugins --no-scripts

		echo "Installing/updating npm dependencies for LIVE"
		npm install --production
	else
		echo "Installing/updating composer dependencies"
		sudo composer install --no-plugins --no-scripts

		echo "Installing/updating npm dependencies"
		npm install
	fi
fi

## (re)-link dist directory for IOLMasterImport module and recompile
dwservrunning=0
# first check if service is running - if it is we stop it, then re-start at the end
if ps ax | grep -v grep | grep run-dicom-service.sh > /dev/null
	then
		dwservrunning=1
		echo "Stopping dicom-file-watcher..."
		sudo service dicom-file-watcher stop
fi

cd /var/www/openeyes/protected/javamodules/IOLMasterImport
sudo rm -rf dist/lib 2>/dev/null || :
sudo mkdir -p dist
sudo ln -s ../lib ./dist/lib
if [ ! $? = 0 ]; then echo "Failure is expeced in pre v1.12 releases (where IOLMasterImport does not exist)"; fi

# Compile IOLImporter
##TODO: When we have more java modules, replace with a generic compilation model
if [ $compile = 1 ]; then
  echo "
  Compiling IOLMAsterImport. Please wait....
  "
  sudo ./compile.sh > /dev/null 2>&1
  if [ ! $? = 0 ]; then echo "Failure is expeced in pre v1.12 releases (where IOLMasterImport does not exist)"; fi
fi

# restart the service if we stopped it
if [ $dwservrunning = 1 ] && [ $resartserv = 1 ]; then
	echo "Restarting dicom-file-watcher..."
	sudo service dicom-file-watcher start
fi

# Automatically migrate up, unless --no-migrate parameter is given
if [ "$migrate" = "1" ]; then
    echo ""
    echo "Migrating database..."
	oe-migrate --quiet
    echo ""
else
	if [ "$nowarnmigrate" = "0" ]; then
	echo "
Migrations were not run automaically. If you need to run the database migrations, run command oe-migrate
"
	fi
fi

# Clear caches
if [ $clearcahes = 1 ]; then
	echo "Clearing caches..."
	sudo rm -rf /var/www/openeyes/protected/runtime/cache/* 2>/dev/null || :
	sudo rm -rf /var/www/openeyes/assets/* 2>/dev/null || :
	echo ""
fi

if [ $buildassests = 1 ]; then
	echo "(re)building assets..."
	# use curl to ping the login page - forces php/apache to rebuild the assets directory
	curl -s http://localhost/site/login > /dev/null
fi

echo ""
echo "...Done"
echo ""
