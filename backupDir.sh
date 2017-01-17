#!/bin/bash
#备份代码目录

#要备份的代码目录
BackupDir="/home/testcode/project/"

#保存备份文件的目录
SaveDir="/home/testcode/"

#备份文件名
BackupFile=${SaveDir}$(date +%Y%m%d%H%M%S).codebackup.tar.gz

#进入目录
if cd $BackupDir ;then
	echo "cd dir:"
	pwd
else
	echo "cannot cd $BackupDir"
	exit 0
fi


find . -type f -regex ".*\.\(php\|html\|js\|css\)" -print0 | tar -T - --ignore-failed-read --null -czvf ${BackupFile} 

if [ ! -f "$BackupFile" ] ;then
	echo "backup directory happen error!"
	exit 0
else
	echo "backup directory done:"$BackupFile
	exit 1
fi
