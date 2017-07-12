#!/bin/bash
#rsync备份GIT项目

#日期
Dday=$(date +%Y%m%d)

#本地备份目录
BackupDir="/home/backup/"${Dday}"/"
#echo $BackupDir

#若本地不存在,则创建
if [ ! -d $BackupDir ];then
  mkdir -p $BackupDir
fi

#远程备份目录
RemoteDir="/home/usr_backup/"${Dday}"/"

#git库目录
repos=(
"/home/code/pro-a"
"/home/code/pro-b"
"/home/code/pro-c"
)

#array length
echo "Checking" ${#repos[@]} "repositories for backup"

for repo in "${repos[@]}"
do
  echo "backuping... " ${repo}
  cd "${repo}"
  git pull
  
  #打包本地备份
  pro=${repo##*/}
  BackupFile=${BackupDir}${pro}.${Dday}.tar.gz
  #echo "pro name:" ${pro}
  git archive --format=tar master | gzip > ${BackupFile}

done

#远程备份
echo "uploading ..."
ssh usr_backup@192.168.1.188 mkdir -p ${RemoteDir} && rsync -avzP -e ssh ${BackupDir} usr_backup@192.168.1.188:${RemoteDir}
echo "complete!"

