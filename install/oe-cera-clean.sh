#!/bin/bash


# Verify we are running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "
USE openeyes;

DROP PROCEDURE IF EXISTS consolidate_int_data_column;
CREATE PROCEDURE consolidate_int_data_column(col_name VARCHAR(256), new_val INT)
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE tab_name VARCHAR(256);
  DECLARE c_tabs CURSOR FOR
    SELECT DISTINCT table_name
    FROM information_schema.COLUMNS
    WHERE column_name = col_name
      AND table_schema = 'openeyes';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN c_tabs;
  consolidate_loop: lOOP
    FETCH c_tabs INTO tab_name;
    IF done THEN LEAVE consolidate_loop; END IF;
    SET @query = concat(' UPDATE openeyes.', tab_name, 
                        ' SET ', col_name, ' = ', new_val,
                        ' WHERE ', col_name ' IS NOT NULL;');
    PREPARE stmt FROM @query;
    EXECUTE stmt;
  END LOOP;
  CLOSE c_tabs;
  COMMIT;
END;

CALL consolidate_int_data_column('firm_id', 1);
CALL consolidate_int_data_column('to_firm_id', 1);
CALL consolidate_int_data_column('archive_firm_id', 1);
CALL consolidate_int_data_column('assignment_firm_id', 1);
CALL consolidate_int_data_column('filter_firm', 1);
CALL consolidate_int_data_column('last_firm_id', 1);
CALL consolidate_int_data_column('consultant', 1);
CALL consolidate_int_data_column('consultant_id', 1);

SET FOREIGN_KEY_CHECKS = 0;
DELETE FROM openeyes.site WHERE id != 1;
CALL consolidate_int_data_column('site_id', 1);
CALL consolidate_int_data_column('last_site_id', 1);
SET FOREIGN_KEY_CHECKS = 1;

DETELE FROM openeyes.firm WHERE id != 1;

DROP PROCEDURE IF EXISTS consolidate_int_data_column;
;;
" > /tmp/openeyes-mysql-consolidate-firms.sql


mysql -u root "-ppassword" --delimiter=";;" < /tmp/openeyes-mysql-consolidate-firms.sql
rm /tmp/openeyes-mysql-consolidate-firms.sql