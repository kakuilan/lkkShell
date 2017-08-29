#!/bin/bash
#自动拉取git项目

#存放的目录
BaseDir="/home/code/"

#项目地址列表
repos=(
"https://github.com/kakuilan/lkkShell.git"
"https://github.com/kakuilan/ktimer.git"
)

#array length
echo "Checking" ${#repos[@]} "repositories for updates..."

for repo in "${repos[@]}"
do
	proname=$(basename $repo ".git")
	prodir=${BaseDir}${proname}
	if [ ! -d "$prodir" ] ;then
		cd "${BaseDir}"
		git clone "${repo}"
	fi

	cd "${prodir}"
	git checkout master >> /dev/null
	git pull
	git status
	echo "pull $proname done."
done
