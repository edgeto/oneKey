#!/bin/bash
###### 定义变量
server_install_log_path="/tmp/server_install.log"
date_show_str=`date '+%Y-%m-%d %H:%M:%S'`
install_nginx_path="/usr/local"
pcre_tar_gz="pcre-8.35.tar.gz" 
pcre_dir="pcre-8.35" 
pcre_name="pcre-8.35" 
nginx_tar_gz="nginx-1.12.0.tar.gz" 
nginx_dir="nginx-1.12.0" 
nginx_name="nginx" 
nginx_upload_config_path="nginx/nginx.conf"
cut_nginx_log_upload_path="nginx/cut_nginx_log.sh"
cut_nginx_log_crontab="/var/spool/cron/root"
install_nginx(){
	##### 一、安装编译工具及库文件
	##### 二、首先要安装 PCRE 
	##### PCRE 作用是让 Ngnix 支持 Rewrite 功能。
	###### 判断文件是否存在
	if [ -e "${install_nginx_path}/${pcre_name}" ]
	then
		echo " ${date_show_str} ----- pcre已经安装 -----"
		echo " ${date_show_str} ----- pcre已经安装 -----" >> ${server_install_log_path}
		##### 查看版本 #####
		pcre_version=`pcre-config --version`
		echo "${date_show_str} ----- pcre版本:${pcre_version} -----"
		echo "${date_show_str} ----- pcre版本:${pcre_version} -----" >> ${server_install_log_path}
	else
		###### 判断文件是否存在
		if [ -e ${pcre_tar_gz} ]
		then
			echo "${date_show_str} ----- 安装编译工具及库文件 -----"
			echo "${date_show_str} ----- 安装编译工具及库文件 -----" >> ${server_install_log_path}
			yum -y install make zlib zlib-devel gcc-c++ libtool  openssl openssl-devel
			echo "${date_show_str} ----- ${pcre_tar_gz}源码文件存在 -----"
			echo "${date_show_str} ----- ${pcre_tar_gz}源码文件存在 -----" >> ${server_install_log_path}
			echo "${date_show_str} ----- 开始安装pcre -----"
			echo "${date_show_str} ----- 开始安装pcre -----" >> ${server_install_log_path}
			echo "${date_show_str} ----- 解压${pcre_tar_gz} -----"
			echo "${date_show_str} ----- 解压${pcre_tar_gz} -----" >> ${server_install_log_path}
			tar zxvf ${pcre_tar_gz}
			cd ${pcre_dir}
			echo "${date_show_str} ----- 执行配置 -----"
			echo "${date_show_str} ----- 执行配置 -----" >> ${server_install_log_path}
			./configure
			echo "${date_show_str} ----- 执行安装 -----"
			echo "${date_show_str} ----- 执行安装 -----" >> ${server_install_log_path}
			make && make install
			##### 返回上一目录
			echo "${date_show_str} ----- 返回上一目录 -----"
			echo "${date_show_str} ----- 返回上一目录 -----" >> ${server_install_log_path}
			cd ../
			mv ${pcre_dir} ${install_nginx_path}/${pcre_name}
			echo "${date_show_str} ----- 成功安装pcre -----"
			echo "${date_show_str} ----- 成功安装pcre -----" >> ${server_install_log_path}
			##### 查看版本 #####
			pcre_version=`pcre-config --version`
			echo "${date_show_str} ----- pcre版本:${pcre_version} -----"
			echo "${date_show_str} ----- pcre版本:${pcre_version} -----" >> ${server_install_log_path}
		else
			echo "${date_show_str} ----- 请先上传${pcre_tar_gz}源码 -----"
			echo "${date_show_str} ----- 请先上传${pcre_tar_gz}源码 -----" >> ${server_install_log_path}
		fi
	fi
	##### 三、安装nginx-1.12.0.tar.gz
	###### 判断文件是否存在
	if [ -e "${install_nginx_path}/${nginx_name}" ]
	then
		echo "${date_show_str} ----- nginx已经安装 -----"
		echo "${date_show_str} ----- nginx已经安装 -----" >> ${server_install_log_path}
		##### 查看版本 #####
		nginx_version=`nginx -v`
		echo "${date_show_str} ----- nginx版本:${nginx_version} -----"
		echo "${date_show_str} ----- nginx版本:${nginx_version} -----" >> ${server_install_log_path}
	else 
		###### 判断文件是否存在
		if [ -e ${nginx_tar_gz} ]
		then
			echo "${date_show_str} ----- ${nginx_tar_gz}源码文件存在 -----"
			echo "${date_show_str} ----- ${nginx_tar_gz}源码文件存在 -----" >> ${server_install_log_path}
			echo "${date_show_str} ----- 开始安装nginx -----"
			echo "${date_show_str} ----- 开始安装nginx -----" >> ${server_install_log_path}
			echo "${date_show_str} ----- 解压${nginx_tar_gz} -----"
			echo "${date_show_str} ----- 解压${nginx_tar_gz} -----" >> ${server_install_log_path}
			tar -zxvf ${nginx_tar_gz}
			cd ${nginx_dir}
			echo "${date_show_str} ----- 执行配置 -----"
			echo "${date_show_str} ----- 执行配置 -----" >> ${server_install_log_path}
			./configure --prefix=${install_nginx_path}/${nginx_name} --with-http_stub_status_module --with-stream --with-http_ssl_module --with-pcre=${install_nginx_path}/${pcre_name}
			echo "${date_show_str} ----- 执行安装 -----"
			echo "${date_show_str} ----- 执行安装 -----" >> ${server_install_log_path}
			make && make install
			##### 创建 Nginx 运行使用的用户 www
			/usr/sbin/groupadd www
			/usr/sbin/useradd -g www www
			##### 返回上一目录
			echo "${date_show_str} ----- 返回上一目录 -----"
			echo "${date_show_str} ----- 返回上一目录 -----" >> ${server_install_log_path}
			cd ../
			##### 修改配置
			cp -rf ${nginx_upload_config_path} ${install_nginx_path}/${nginx_name}/conf/
			##### 设置启动脚本
			echo "${install_nginx_path}/${nginx_name}/sbin/nginx" >> /etc/rc.local
			##### 启动nginx
			echo "${date_show_str} ----- 启动nginx -----"
			echo "${date_show_str} ----- 启动nginx -----" >> ${server_install_log_path}
			${install_nginx_path}/${nginx_name}/sbin/nginx
			##### 设置变量环境
			echo "${date_show_str} ----- 设置变量环境 -----"
			echo "${date_show_str} ----- 设置变量环境 -----" >> ${server_install_log_path}
			echo "PATH=$PATH:${install_nginx_path}/${nginx_name}/sbin" >> /etc/profile
			export PATH=$PATH:${install_nginx_path}/${nginx_name}/sbin
			cut_nginx_log
			echo "${date_show_str} ----- 成功安装nginx -----"
			echo "${date_show_str} ----- 成功安装nginx -----" >> ${server_install_log_path}
			##### 查看版本 #####
			nginx_version=`nginx -v`
			echo "${date_show_str} ----- nginx版本:${nginx_version} -----"
			echo "${date_show_str} ----- nginx版本:${nginx_version} -----" >> ${server_install_log_path}
		else
			echo "----- 请先上传${nginx_tar_gz}源码 -----"
			echo "----- 请先上传${nginx_tar_gz}源码 -----" >> ${server_install_log_path}
		fi
	fi 
}
cut_nginx_log(){
	echo "${date_show_str} ----- 安装nginx定时切割日志 -----" 
	echo "${date_show_str} ----- 安装nginx定时切割日志 -----" >> ${server_install_log_path}
	##### 安装crond服务
	yum -y install vixie-cron crontabs
	cp -rf ${cut_nginx_log_upload_path} ${install_nginx_path}/${nginx_name}/sbin/
	##### 赋予执行权限
	chmod +x ${install_nginx_path}/${nginx_name}/sbin/cut_nginx_log.sh
	##### 设置定时任务，每天00:00定时执行
	##### crontab -e
	##### 00 * * * /usr/local/nginx/sbin/cut_nginx_log.sh
	echo "00 * * * ${install_nginx_path}/${nginx_name}/sbin/cut_nginx_log.sh" >> ${cut_nginx_log_crontab}
	##### 启动crond服务
	chkconfig crondon
	service crond start
}
##### 执行函数
install_nginx
