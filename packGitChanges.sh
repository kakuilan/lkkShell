#!/bin/bash
#打包GIT两个版本之间变更的文件列表

#git项目目录
ProjectDir="/root/mycode/project/"

#保存备份文件的目录
SaveDir="/home/testcode/"

#备份文件名
PackFile=${SaveDir}$(date +%Y%m%d%H%M%S).gitUpdate.tar.gz

#获取git分支
echo -n "Enter git-branch and press [ENTER],default(master): "
read -r branch
if [ ! -n "$branch" ];then
  branch="master"
fi

#获取输入的git两个版本号
echo -n "Enter firstVersionCode and press [ENTER]: "
read -r firstcode
echo -n "Enter secondVersionCode and press [ENTER]: "
read -r secondcode

if [ ! -n "$firstcode" ] ;then 
    echo "firstcode is null word!"
        exit 0  
elif [ ! -n "$secondcode" ];then
    echo "secondcode is null word!"
        exit 0  
fi

echo "firstcode: "$firstcode
echo "secondcode: "$secondcode

#进入目录
if cd $ProjectDir ;then
	echo "cd dir:"
	pwd
else
	echo "cannot cd $ProjectDir"
	exit 0
fi

//切换所选分支
git pull
if [ "$branch" != "master" ]; then  
	git checkout $branch
fi

#git对比并打包
#git diff $firstcode $secondcode --name-only | xargs tar --ignore-failed-read -czvf $PackFile
git diff $firstcode $secondcode --name-only |grep '^[^.].*[^.sql]$'| xargs tar --ignore-failed-read -czvf $PackFile

#切回主分支
if [ "$branch" != "master" ]; then  
	git checkout master
fi

if [ ! -f "$PackFile" ] ;then
	echo "pack git update files happen error."
	exit 0
else
	echo "pack git update files done:"$PackFile
	exit 1
fi
