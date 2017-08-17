#!/bin/bash


# Verify we are running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "
USE openeyes

DROP PROCEDURE IF EXISTS  make_cera;
CREATE PROCEDURE make_cera()
BEGIN
  DECLARE contact_id, import_source_id, institution_id INT;

  INSERT INTO openeyes.import_source
  (name, created_user_id, last_modified_user_id, created_date, last_modified_date)
  VALUES  ('Fivium Australia', 1, 1, NOW(), NOW());
  SET import_source_id = LAST_INSERT_ID();

  INSERT INTO openeyes.contact (nick_name, primary_phone, title, first_name, last_name, qualifications, last_modified_user_id, last_modified_date, created_user_id, created_date, contact_label_id, maiden_name)
  VALUES ('NULL', 'NULL', null, '', '', null, 1, NOW(), 1, NOW(), null, null);
  SET contact_id = LAST_INSERT_ID();

  INSERT INTO openeyes.institution
  (name, remote_id, last_modified_user_id, last_modified_date, created_user_id, created_date, short_name, contact_id, source_id, active)
  VALUES ('Center for Eye Research Australia', 'CERA', 1, NOW(), 1, NOW(), '', 576752, import_source_id, 1);
  set institution_id = LAST_INSERT_ID();

  INSERT INTO openeyes.site
  (name, remote_id, short_name, location_code, fax, telephone, last_modified_user_id, last_modified_date, created_user_id, created_date, institution_id, location, contact_id, replyto_contact_id, source_id, active)
  VALUES ('Center for Eye Research Australia', 'CERA', 'CERA', '', '', '0399298360', 1, NOW(), 1, NOW(), institution_id, '', contact_id, null, import_source_id, 1);
END;
CALL make_cera;
DROP PROCEDURE IF EXISTS make_cera;

SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM user WHERE id != 1;
DELETE FROM patient;
SET FOREIGN_KEY_CHECKS = 1;

UPDATE firm SET active = FALSE WHERE id !=1 AND consultant_id IS NOT NULL;
UPDATE institution SET active = FALSE WHERE LOWER(name) NOT LIKE '%center for eye research%';
UPDATE site SET active = FALSE WHERE remote_id != 'CERA';
;;
" > /tmp/openeyes-mysql-cera-setup.sql


mysql -u root "-ppassword" --delimiter=";;" < /tmp/openeyes-mysql-cera-setup.sql
rm /tmp/openeyes-mysql-cera-setup.sql