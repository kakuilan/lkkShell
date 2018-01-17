#/bin/bash
DB=my_test
USER=root
PASSWD=root
HOST=localhost
MYSQL_BIN=/usr/local/mysql/bin 
S_ENGINE=MyISAM   ###原引擎
D_ENGINE=InnoDB   ###修改后的引擎
#echo "Enter MySQL bin path:"
#read MYSQL_BIN
#echo "Enter Host:"
#read HOST
#echo "Enter Uesr:"
#read USER
#echo "Enter Password:"
#read PASSWD
#echo "Enter DB name :"
#read DB
#echo "Enter the original engine:"
#read S_ENGINE
#echo "Enter the new engine:"
#read D_ENGINE
$MYSQL_BIN/mysql -h$HOST -u$USER -p$PASSWD $DB -e "select TABLE_NAME from information_schema.TABLES where 
 
TABLE_SCHEMA='"$DB"' and ENGINE='"$S_ENGINE"';" | grep -v "TABLE_NAME" >tables.txt
for t_name in `cat tables.txt`
do
    echo "Starting convert table $t_name......"
    sleep 1
    $MYSQL_BIN/mysql -h$HOST -u$USER -p$PASSWD $DB -e "alter table $t_name engine='"$D_ENGINE"'"
    if [ $? -eq 0 ]
    then
        echo "Convert table $t_name ended." >>con_table.log
        sleep 1
    else
        echo "Convert failed!" >> con_table.log
    fi
done
