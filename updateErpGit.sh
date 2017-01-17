#!/bin/bash
#更新检出多个GIT库

repos=(
"/usr/local/nginx/html/erpp"
"/usr/local/nginx/html/erp_pro"
"/usr/local/nginx/html/erp_lite"
)

#array length
echo "Checking" ${#repos[@]} "repositories for updates"


for repo in "${repos[@]}"
do
  echo "updating... " ${repo}
  cd "${repo}"
  git pull
  git status
done
