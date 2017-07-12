#!/bin/bash
logs_path="/usr/local/nginx/logs/"
backup_path="/home/logs/"
mv ${logs_path}access.log ${backup_path}access_$(date +"%Y%m%d").log
mv ${logs_path}error.log ${backup_path}error_$(date +"%Y%m%d").log
/usr/local/nginx/sbin/nginx -s reopen