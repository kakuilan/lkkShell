#!/bin/bash
#====================================================
# Author: gnpok- EMail:742926717@qq.com
# CreateTime: 2015-5-21 
# Filename:base.sh 
# Description:iptables网站基本防护

#===============开发基本端口=========================
iptables -I INPUT -p icmp -m limit --limit 1/m --limit-burst 5 -j ACCEPT
#允许ping,但对ping限制速度
iptables -A INPUT -p icmp  -j DROP #在限制外部分都回拒

iptables -A INPUT -p tcp --dport 22 -j ACCEPT #开放ssh端口
#防止暴力破解ssh密码 可以使用fail2ban软件
#iptables -A INPUT -p tcp --dport 10：20  -j ACCEPT #允许10到20端口范围




#===============对网站访问限制部分====================
iptables -A INPUT -p tcp --dport 80 -m connlimit --connlimit-above 20 -j REJECT #单个ip最大连接数30
#这个针对压力软件 ab -nxxx -cxxx http//xxx  对同时请求数即-c数量限制

#对同一ip在多少时间内访问量限制
#参考https://github.com/ProgramMaster/dns-anti-DDoS
#iptables -A INPUT -p tcp --dport 80 -m state --state NEW -m recent --set --name DDOS --rsource
#iptables -A INPUT -p tcp --dport 80 -m state --state NEW -m recent --update --seconds 1 --hitcount 10 --name DDOS --rsource -j DROP #对1秒超过15个请求直接DROP
iptables -A INPUT -p tcp --dport 80 -m recent --name BAD_HTTP_ACCESS --update --seconds 60 --hitcount 30 -j REJECT iptables -A INPUT -p tcp --dport 80 -m recent --name BAD_HTTP_ACCESS --set -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT #开放80端口

#===============拒绝其他端口访问,并可以登陆ftp========
iptables -A INPUT -i lo -j ACCEPT #允许本地回环
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT #允许访问外网
iptables -A INPUT -j DROP #拒绝其他所有端口访问


#===============通过iptables防止扫描================
#防止同步包洪水（Sync Flood）
iptables -A FORWARD -p tcp --syn -m limit --limit 1/s --limit-burst 5 -j ACCEPT
#防止各种端口扫描
iptables -A FORWARD -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s -j ACCEPT
#Ping洪水攻击（Ping of Death）
iptables -A FORWARD -p icmp --icmp-type echo-request -m limit --limit 1/s -j ACCEPT
