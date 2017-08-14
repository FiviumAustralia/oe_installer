#!/bin/bash


# Verify we are running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "
USE openeyes

INSERT INTO openeyes.import_source
  (name, created_user_id, last_modified_user_id, created_date, last_modified_date)
VALUES
  ('Fivium Australia', 1, 1, '1900-01-01 00:00:00', '1900-01-01 00:00:00');

INSERT INTO openeyes.institution
  (name, remote_id, last_modified_user_id, last_modified_date, created_user_id, created_date, short_name, contact_id, source_id, active)
VALUES
  ('Center for Eye Research Australia', 'CERA', 1, NOW(), 1, NOW(), '', 576752, LAST_INSERT_ID(), 1);

INSERT INTO openeyes.site
  (name, remote_id, short_name, location_code, fax, telephone, last_modified_user_id, last_modified_date, created_user_id, created_date, institution_id, location, contact_id, replyto_contact_id, source_id, active)
VALUES
  ('Center for Eye Research Australia', 'CERA', 'CERA', '', '', '0399298360', 1, NOW(), 1, NOW(), LAST_INSERT_ID(), '', 576755, null, null, 1);

UPDATE institution SET active = FALSE WHERE LOWER(name) NOT LIKE '%center for eye research%';
UPDATE site SET active = TRUE WHERE remote_id != 'CERA';
;;
" > /tmp/openeyes-mysql-cera-setup.sql


mysql -u root "-ppassword" --delimiter=";;" < /tmp/openeyes-mysql-cera-setup.sql
rm /tmp/openeyes-mysql-cera-setup.sql