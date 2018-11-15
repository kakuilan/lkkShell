#!/bin/bash
#vue项目打包发布

#本地git项目代码目录
RepsDir="/home/vagrant/workcode/vuetest"

#远程发布目录
PublishDir="/data/wwwroot/vuetest.com"

#拉取最新代码
echo "updating... "
cd $RepsDir
git checkout master
git fetch origin && git reset --hard origin/master
git pull

#项目安装模块并打包
cnpm install && cnpm run build

#发布到远程机
rsync -vzr -e ssh dist/ user@192.168.2.1:${PublishDir}

