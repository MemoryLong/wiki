#!/bin/bash

# 检查是否为 root 用户
if [ "$(id -u)" -ne 0 ]; then
  echo "此脚本需要 root 权限"
  exit 1
fi

# 检查是否提供了新的主机名
if [ -z "$1" ]; then
  echo "用法: $0 新的主机名"
  exit 1
fi

NEW_HOSTNAME=$1

# 设置新的主机名
hostnamectl set-hostname "$NEW_HOSTNAME"

# 更新 /etc/hosts 文件
sed -i "s/127.0.1.1.*/127.0.1.1 $NEW_HOSTNAME/g" /etc/hosts

# 确认主机名更改
echo "主机名已更改为: $NEW_HOSTNAME"
echo "请重新启动系统以应用更改。"

# 重新启动网络服务（可选）
systemctl restart networking

exit 0

#chmod +x vmInit-hostName.sh
#sudo ./vmInit-hostName.sh mysqlserver
