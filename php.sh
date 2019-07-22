#!/bin/bash
###### 定义变量
server_install_log_path="/tmp/server_install.log"
date_show_str=`date '+%Y-%m-%d %H:%M:%S'`
install_php_path="/usr/local"
libmcryptp_tar_gz="libmcrypt-2.5.8.tar.gz" 
libmcrypt_dir="libmcrypt-2.5.8" 
libmcrypt_name="libmcrypt" 
php_tar_gz="php-7.1.7.tar.gz" 
php_dir="php-7.1.7" 
php_name="php" 
php_upload_config_path="php/www.conf"
php_opcache_path="php/opcache.txt"
install_php(){
	###### 判断文件是否存在
	if [ -e "${install_php_path}/${php_name}" ]
	then
		echo "${date_show_str} ----- php已经安装 -----"
		echo "${date_show_str} ----- php已经安装 -----" >> ${server_install_log_path}
		php_version=`php -v`
		echo "${date_show_str} ----- php版本:${php_version} -----"
		echo "${date_show_str} ----- php版本:${php_version} -----" >> ${server_install_log_path}
	else
		##### libmcrypt安装
		if [ -e "${libmcryptp_tar_gz}" ]
		then
			echo "${date_show_str} ----- ${libmcryptp_tar_gz}源码文件存在 -----"
			echo "${date_show_str} ----- ${libmcryptp_tar_gz}源码文件存在 -----" >> ${server_install_log_path}
			echo "${date_show_str} ----- 解压${libmcryptp_tar_gz} -----"
			echo "${date_show_str} ----- 解压${libmcryptp_tar_gz} -----" >> ${server_install_log_path}
			tar zxvf ${libmcryptp_tar_gz}
			cd ${libmcrypt_dir}
			./configure
			make && make install
			echo "${date_show_str} ----- 成功安装libmcrypt -----"
			echo "${date_show_str} ----- 成功安装libmcrypt -----" >> ${server_install_log_path}
			##### 返回上一目录
			echo "${date_show_str} ----- 返回上一目录 -----"
			echo "${date_show_str} ----- 返回上一目录 -----" >> ${server_install_log_path}
			cd ../
		else
			echo "${date_show_str} ----- 请先上传${libmcryptp_tar_gz}源码 -----"
			echo "${date_show_str} ----- 请先上传${libmcryptp_tar_gz} -----" >> ${server_install_log_path}
		fi
		###### 判断文件是否存在
		if [ -e ${php_tar_gz} ]
		then
			echo "${date_show_str} ----- ${php_tar_gz}源码文件存在 -----"
			echo "${date_show_str} ----- ${php_tar_gz}源码文件存在 -----" >> ${server_install_log_path}
			##### PHP安装（fastcgi运行模式）
			##### 安装相关库文件
			echo "${date_show_str} ----- 安装相关库文件 -----"
			echo "${date_show_str} ----- 安装相关库文件 -----" >> ${server_install_log_path}
			yum -y install libmcrypt-devel mhash-devel libxslt-devel libjpeg libjpeg-devel libpng libpng-devel freetype freetype-devel libxml2 libxml2-devel zlib zlib-devel glibc glibc-devel glib2 glib2-devel bzip2 bzip2-devel ncurses ncurses-devel curl curl-devel e2fsprogs e2fsprogs-devel krb5 krb5-devel libidn libidn-devel openssl openssl-devel gcc gcc-c++
			echo "${date_show_str} ----- 解压${php_tar_gz} -----"
			echo "${date_show_str} ----- 解压${php_tar_gz} -----" >> ${server_install_log_path}
			tar zxvf ${php_tar_gz}
			cd ${php_dir}
			echo "${date_show_str} ----- 执行配置 -----"
			echo "${date_show_str} ----- 执行配置 -----" >> ${server_install_log_path}
			./configure --prefix=${install_php_path}/${php_name} \
			--with-curl \
			--with-freetype-dir \
			--with-gd \
			--with-gettext \
			--with-iconv-dir \
			--with-kerberos \
			--with-libdir=lib64 \
			--with-libxml-dir \
			--with-mysqli \
			--with-openssl \
			--with-pcre-regex \
			--with-pdo-mysql \
			--with-pdo-sqlite \
			--with-pear \
			--with-png-dir \
			--with-xmlrpc \
			--with-xsl \
			--with-zlib \
			--enable-fpm \
			--enable-bcmath \
			--enable-libxml \
			--enable-inline-optimization \
			--enable-gd-native-ttf \
			--enable-mbregex \
			--enable-mbstring \
			--enable-opcache \
			--enable-pcntl \
			--enable-shmop \
			--enable-soap \
			--enable-sockets \
			--enable-sysvsem \
			--enable-xml \
			--enable-zip \
			--with-jpeg-dir \
			--with-mcrypt \
			--enable-exif
			##### 执行安装
			echo "${date_show_str} ----- 执行安装 -----"
			echo "${date_show_str} ----- 执行安装 -----" >> ${server_install_log_path}
			make && make install
			##### 修改配置文件
			cp -rf php.ini-development ${install_php_path}/${php_name}/lib/php.ini
			cp -rf ${install_php_path}/${php_name}/etc/php-fpm.conf.default ${install_php_path}/${php_name}/etc/php-fpm.conf
			##### cp /usr/local/php/etc/php-fpm.d/www.conf.default /usr/local/php/etc/php-fpm.d/www.conf
			##### 开机启动
			#### cp -Rf ./sapi/fpm/php-fpm /etc/init.d/php-fpm
			cp sapi/fpm/init.d.php-fpm /etc/init.d/php-fpm
			echo "${date_show_str} ----- 成功安装php -----"
			echo "${date_show_str} ----- 成功安装php -----" >> ${server_install_log_path}
			##### 设置变量环境
			echo "${date_show_str} ----- 设置变量环境 -----"
			echo "${date_show_str} ----- 设置变量环境 -----" >> ${server_install_log_path}
			echo "PATH=$PATH:${install_php_path}/${php_name}/sbin" >> /etc/profile
			export PATH=$PATH:${install_php_path}/${php_name}/sbin
			echo "PATH=$PATH:${install_php_path}/${php_name}/bin" >> /etc/profile
			export PATH=$PATH:${install_php_path}/${php_name}/bin
			php_version=`php -v`
			echo "${date_show_str} ----- php版本:${php_version} -----"
			echo "${date_show_str} ----- php版本:${php_version} -----" >> ${server_install_log_path}
			##### 返回上一目录
			echo "${date_show_str} ----- 返回上一目录 -----"
			echo "${date_show_str} ----- 返回上一目录 -----" >> ${server_install_log_path}
			cd ../
			cp -rf ${php_upload_config_path} ${install_php_path}/${php_name}/etc/php-fpm.d/www.conf
			##### opcache 配置
			cat ${php_opcache_path} >> ${install_php_path}/${php_name}/lib/php.ini
			##### 启动
			chmod +x /etc/init.d/php-fpm 
			echo "${date_show_str} ----- 启动php -----"
			echo "${date_show_str} ----- 启动php -----" >> ${server_install_log_path}
			/etc/init.d/php-fpm
		else
			echo "${date_show_str} ----- 请先上传${php_tar_gz}源码 -----"
			echo "${date_show_str} ----- 请先上传${php_tar_gz}源码 -----" >> ${server_install_log_path}
		fi
	fi
}
##### 执行函数
install_php
