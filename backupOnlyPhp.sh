#!/bin/bash
#只压缩备份目录下PHP文件
fname=$(date +%Y%m%d%H%M%S).backupphp.tar.gz
#find /home/testcode/ -type f -regex ".*\.\(php\|js\|html\|css\)" | xargs tar czvf $fname
find /home/testcode/ -type f -regex ".*\.\(php\)" | xargs tar czvf $fname
echo $fname "backup only php done."
