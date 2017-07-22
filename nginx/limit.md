### nginx防止被压力测试的设置方法：  
##### 限制同一IP并发数最大为10  
* vim /etc/nginx/nginx.conf  
http{}字段第一行添加：
```
limit_conn_zone $binary_remote_addr zone=one:10m;  
```
* vim /etc/nginx/conf.d/default  
server{}字段添加：  
```
limit_conn one 10;  
```
####重启nginx
>service nginx restart  
