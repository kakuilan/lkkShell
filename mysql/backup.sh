#!/bin/bash

#设置文件存放目录
myPath="/mysql/mysqldata_bakeup"
if [ ! -d "$myPath" ]; then 
mkdir -p "$myPath" 
fi 

time=`date +%Y%m%d`
#数据库配置部分
host="127.1.0.1"
user="root"
pass=""
db="test"

mysqldump  -u$user -p$pass  $db| gzip > $myPath/$db$time.sql.gz
#删除7天之前的数据
find $backupdir/ -name "$db*.sql.gz" -type f -mtime +5 -exec rm -f {} \; > /dev/null 2>&1

#在crontab里面增加的内容,每天凌晨3点备份
#vim /etc/crontab                                                                            
# m h  dom mon dow   command
# 0 3   *   *   *   root /var/backup/backup-mysql.sh
#分钟执行在/etc/crontab下面
# */1 *   *   *   *   root /var/backup/backup-mysql.sh

#crontab -e
# */1 *   *   *   *  /var/backup/backup-mysql.sh
