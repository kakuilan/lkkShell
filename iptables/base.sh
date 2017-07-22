#!/bin/bash
#iptables最基础的防护策略

#少了这句当drop所有时候，ssh都登陆不了服务器
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

#添加需要放行的服务端口
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
#添加本地回环
sudo iptables -I INPUT 1 -i lo -j ACCEPT
#将不满足规则的一律封杀
sudo iptables -P INPUT DROP
