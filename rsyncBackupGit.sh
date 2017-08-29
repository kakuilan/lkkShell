#!/bin/bash
#rsync备份GIT项目

#日期
Dday=$(date +%Y%m%d)

#本地备份目录
LocalDir="/home/backup/"
BackupDir=${LocalDir}${Dday}"/"
#echo $BackupDir

#若本地不存在,则创建
if [ ! -d $BackupDir ];then
	mkdir -p $BackupDir
fi

#检查备份目录是否在/home目录下,防止误删除/或其他目录
Home="/home"
if [[ ${LocalDir/${Home}//} == $Home ]];then
	echo "BackupDir not in $BackupDir"
else
	#删除今日外的备份
	cd ${LocalDir}
	rm -rf `ls . | grep -v "^$Dday$"`
fi

#远程备份目录
RemoteDir="/home/usr_backup/"${Dday}"/"

#库目录
RepsDir="/home/code/"
repos=(
"https://github.com/kakuilan/lkkShell.git"
"https://github.com/kakuilan/ktimer.git"
)

#array length
echo "Checking" ${#repos[@]} "repositories for backup"

for repo in "${repos[@]}"
do
	proname=$(basename $repo ".git")
	prodir=${RepsDir}${proname}
	if [ ! -d "$prodir" ] ;then
		cd $RepsDir
		git clone "${repo}"
	fi

	#pro=${repo##*/}
	echo "backuping... " ${proname}
	cd $prodir
	git checkout master
	git pull

	#打包本地备份
	BackupFile=${BackupDir}${proname}.${Dday}.tar.gz
	git archive --format=tar master | gzip > ${BackupFile}

	echo "Package [${proname}] complete."
done

#远程备份
echo "uploading ..."
ssh usr_backup@192.168.1.188 mkdir -p ${RemoteDir} && rsync -avzP -e ssh ${BackupDir} usr_backup@192.168.1.188:${RemoteDir}
echo "complete!"