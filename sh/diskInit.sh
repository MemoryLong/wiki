#!/bin/bash

# 设置变量
MOUNT_POINT="/appdata"

# 查找新的未使用磁盘
NEW_DISK=$(lsblk -dpno name | grep -Ev "sda|sr0" | head -n 1)

# 检查是否找到新磁盘
if [ -z "$NEW_DISK" ]; then
    echo "未找到新的磁盘。"
    exit 1
fi

# 创建新的分区
echo "在 $NEW_DISK 上创建分区..."
sudo parted -s "$NEW_DISK" mklabel gpt
sudo parted -s -a optimal "$NEW_DISK" mkpart primary ext4 0% 100%

# 等待分区识别
sleep 5

# 获取新分区的路径
NEW_PARTITION=$(lsblk -no name "$NEW_DISK" | grep -Ev "sda|sr0" | tail -n 1)
NEW_PARTITION="/dev/$NEW_PARTITION"

# 格式化分区
echo "格式化分区 $NEW_PARTITION..."
sudo mkfs.ext4 "$NEW_PARTITION"

# 创建挂载点
if [ ! -d "$MOUNT_POINT" ]; then
    echo "创建挂载点 $MOUNT_POINT..."
    sudo mkdir -p "$MOUNT_POINT"
fi

# 挂载分区
echo "挂载分区 $NEW_PARTITION 到 $MOUNT_POINT..."
sudo mount "$NEW_PARTITION" "$MOUNT_POINT"

# 获取分区的 UUID
UUID=$(sudo blkid -s UUID -o value "$NEW_PARTITION")

# 将分区添加到 /etc/fstab 以便开机自动挂载
echo "将 $NEW_PARTITION 添加到 /etc/fstab..."
echo "UUID=$UUID $MOUNT_POINT ext4 defaults 0 2" | sudo tee -a /etc/fstab

# 显示结果
echo "磁盘 $NEW_DISK 已成功分区、格式化，并挂载到 $MOUNT_POINT。"
