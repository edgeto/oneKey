#!/bin/bash
##### author：edgeto
##### 系统平台：CentOS
##### vim编辑器打开脚本, 运行::set ff?可以看到DOS或UNIX的字样. 使用set ff=unix把它强制为unix格式的, 然后存盘退出, 即可.
##### 网上也有很多的其他方法, 比如: 执行dos2unix 命令转换编码, 命令为: #dos2unix server.sh
##### 一键安装PHP7环境
##### 安装日志path
##### server_install_path="/tmp/server_install.log"
##### 一、安装nginx，详细看nginx.txt和nginx.sh
##### 引入nginx.sh
./nginx.sh
##### 二、安装php，详细看php.txt和php.sh
##### 引入php.sh
./php.sh
##### 三、安装php扩展
##### 引入php_extend.sh 有问题，先手动安装
##### ./php_extend.sh
##### 四、安装mysql
##### 此处用开箱即用安装方法，不用源码安装，详情请看mysql.txt

