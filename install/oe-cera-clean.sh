#!/bin/bash


# Verify we are running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "
USE openeyes

SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM user WHERE id != 1;
DELETE FROM patient;
DELETE FROM ophtrintravitinjection_injectionuser;
DELETE FROM ophtrlaser_laser_operator;
SET FOREIGN_KEY_CHECKS = 1;

UPDATE firm SET active = FALSE WHERE id !=1 AND consultant_id IS NOT NULL;
UPDATE institution SET active = FALSE WHERE LOWER(name) NOT LIKE '%center for eye research%';
UPDATE site SET active = FALSE WHERE remote_id != 'CERA';
;;
" > /tmp/openeyes-mysql-cera-setup.sql


mysql -u root "-ppassword" --delimiter=";;" < /tmp/openeyes-mysql-cera-setup.sql
rm /tmp/openeyes-mysql-cera-setup.sql