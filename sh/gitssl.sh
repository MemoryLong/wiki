#!/bin/bash

# 变量
KEYNAME="webserver"

# 生成新的 SSH 密钥
ssh-keygen -t $KEYNAME -b 4096 -C "haifeng222222@sina.com"

# 添加 SSH 密钥到 SSH 代理
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/$KEYNAME

# 打开 id_rsa.pub 文件并复制内容
cat ~/.ssh/$KEYNAME.pub
# 登录到你的 GitHub 账户。
# 导航到 Settings -> SSH and GPG keys -> New SSH key。
# 粘贴你的公钥内容并保存。

# 在 GitHub 上添加 SSH 公钥

# 测试 SSH 连接
ssh -T git@github.com