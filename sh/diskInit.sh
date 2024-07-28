#!/bin/bash

# 变量
DISK="/dev/sdb"
VG_NAME="appvg"
LV_NAME="applv"
MOUNT_POINT="/appdata"

# 检查磁盘是否存在
if [ ! -b "$DISK" ]; then
    echo "磁盘 $DISK 不存在。"
    exit 1
fi

# 检查磁盘是否已经使用
if sudo pvs | grep -q "$DISK"; then
    echo "磁盘 $DISK 已在使用。"
    exit 0
fi

# 创建物理卷
echo "创建物理卷 $DISK..."
sudo pvcreate "$DISK"

# 创建卷组
echo "创建卷组 $VG_NAME..."
sudo vgcreate "$VG_NAME" "$DISK"

# 创建逻辑卷
echo "创建逻辑卷 $LV_NAME..."
sudo lvcreate -l 100%FREE -n "$LV_NAME" "$VG_NAME"

# 格式化逻辑卷
echo "格式化逻辑卷 /dev/$VG_NAME/$LV_NAME..."
sudo mkfs.ext4 "/dev/$VG_NAME/$LV_NAME"

# 创建挂载点
if [ ! -d "$MOUNT_POINT" ]; then
    echo "创建挂载点 $MOUNT_POINT..."
    sudo mkdir -p "$MOUNT_POINT"
fi

# 挂载逻辑卷
echo "挂载逻辑卷 /dev/$VG_NAME/$LV_NAME 到 $MOUNT_POINT..."
sudo mount "/dev/$VG_NAME/$LV_NAME" "$MOUNT_POINT"

# 获取逻辑卷的 UUID
UUID=$(sudo blkid -s UUID -o value "/dev/$VG_NAME/$LV_NAME")

# 将逻辑卷添加到 /etc/fstab 以便开机自动挂载
echo "将 /dev/$VG_NAME/$LV_NAME 添加到 /etc/fstab..."
echo "UUID=$UUID $MOUNT_POINT ext4 defaults 0 2" | sudo tee -a /etc/fstab

# 显示结果
echo "磁盘 $DISK 已成功配置为逻辑卷，并挂载到 $MOUNT_POINT。"
