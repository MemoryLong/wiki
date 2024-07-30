#!/bin/bash

#sudo touch gitssl.sh
#sudo chmod +x gitssl.sh
# 变量
KEYNAME="webserver"
sudo -i
# 生成新的 SSH 密钥
ssh-keygen -t rsa -b 4096 -C "haifeng222222@sina.com" -f /root/.ssh/$KEYNAME_rsa

# 添加 SSH 密钥到 SSH 代理
#eval "$(ssh-agent -s)"
#ssh-add /root/.ssh/$KEYNAME_rsa
# 以下是一个完整的 /root/.ssh/config 示例，其中包含多个主机的配置：
# Host github.com
#   HostName github.com
#   User git
#   IdentityFile ~/.ssh/id_rsa
#   IdentitiesOnly yes

# 配置 GitLab
# Host gitlab.com
#   HostName gitlab.com
#   User git
#   IdentityFile ~/.ssh/id_rsa_gitlab
#   IdentitiesOnly yes

# 打开 id_rsa.pub 文件并复制内容
cat /root/.ssh/$KEYNAME_rsa.pub
# 登录到你的 GitHub 账户。
# 导航到 Settings -> SSH and GPG keys -> New SSH key。
# 粘贴你的公钥内容并保存。

# 在 GitHub 上添加 SSH 公钥

# 测试 SSH 连接
ssh -T git@github.com
