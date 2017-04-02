#!/bin/bash

# first remove any existing temp file
rm -rf /tmp/sql.tmp

# now concatenate all the sql commands to create and populate the DB
cat populateDB.sql > /tmp/sql.tmp

# now execute the commands in the concatenated file and run them through mysql
cat /tmp/sql.tmp | mysql -uroot -p -t -vvv --show_warnings

# clean up
rm -rf /tmp/sql.tmp
