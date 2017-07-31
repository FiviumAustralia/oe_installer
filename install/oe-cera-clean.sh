#!/bin/bash


# Verify we are running as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

echo "
USE openeyes ;

DROP PROCEDURE IF EXISTS consolidate_firms;
CREATE PROCEDURE consolidate_firms()
BEGIN
  DECLARE done INT DEFAULT FALSE;
  DECLARE tab_name VARCHAR(256);
  DECLARE col_name VARCHAR(256);
  DECLARE c_tabs CURSOR FOR
    SELECT DISTINCT table_name, column_name
    FROM information_schema.COLUMNS
    WHERE column_name IN (
        'firm_id'
      , 'to_firm_id'
      , 'archive_firm_id'
      , 'assignment_firm_id'
      , 'filter_firm'
      , 'last_firm_id'
      )
      AND table_schema = 'openeyes';
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

  OPEN c_tabs;
  consolidate_loop: lOOP
    FETCH c_tabs INTO tab_name, col_name;
    IF done THEN LEAVE consolidate_loop; END IF;
    SET @query = concat('UPDATE openeyes.', tab_name, ' SET ', col_name, ' = 1;');
    PREPARE stmt FROM @query;
    EXECUTE stmt;
  END LOOP;
  CLOSE c_tabs;
  COMMIT;
END;

CALL consolidate_firms();
DROP PROCEDURE IF EXISTS consolidate_firms;
;;
" > /tmp/openeyes-mysql-consolidate-firms.sql


mysql -u root "-ppassword" --delimiter=";;" < /tmp/openeyes-mysql-consolidate-firms.sql
rm /tmp/openeyes-mysql-consolidate-firms.sql