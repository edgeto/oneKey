#!/bin/bash
###### redis服务安装 安装方法持别，所以放在最后
###### 定义变量 配置修改请查看redis/redis.txt
redis_server_tar_gz="redis-3.0.7.tar.gz" 
redis_server_dir="redis-3.0.7" 
redis_server_name="redis" 
redis_server_path="/usr/local/redis"
local_pwd=`pwd`

##### redis_server安装
if [ -e "${redis_server_tar_gz}" ]
then
	echo "${date_show_str} ----- ${redis_server_tar_gz}源码文件存在 -----"
	echo "${date_show_str} ----- ${redis_server_tar_gz}源码文件存在 -----" >> ${server_install_log_path}
	echo "${date_show_str} ----- 解压${redis_server_tar_gz} -----"
	echo "${date_show_str} ----- 解压${redis_server_tar_gz} -----" >> ${server_install_log_path}
	tar zxvf ${redis_server_tar_gz}
	cp -r ${redis_server_dir} ${redis_server_path} 
	cd ${redis_server_path}
	make && make install
	cp redis.conf /etc/
	##### 将redis添加到自启动中  
	echo "/usr/local/bin/redis-server /etc/redis.conf" >> /etc/rc.d/rc.local
	##### 启动redis  
	redis-server /etc/redis.conf
	echo "${date_show_str} ----- 成功安装redis_server -----"
	echo "${date_show_str} ----- 成功安装redis_server -----" >> ${server_install_log_path}
	##### 返回上一目录
	echo "${date_show_str} ----- 返回上一目录 -----"
	echo "${date_show_str} ----- 返回上一目录 -----" >> ${server_install_log_path}
	cd ${local_pwd}
else
	echo "${date_show_str} ----- 请先上传${redis_server_tar_gz}源码 -----"
	echo "${date_show_str} ----- 请先上传${redis_server_tar_gz} -----" >> ${server_install_log_path}
fi