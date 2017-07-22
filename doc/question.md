### sh No such file or directory
在window平台下，写好shell脚本文件，迁移到linux平台，赋过可执行权限，执行该sh文件，却提示No such file or directory.这是文件格式兼容性问题.解决:

vi x.sh  

:set ff  

回车,显示fileformat=dos  


重新设置下文件格式:  

:set ff=unix  

:set nobomb  

:wq

