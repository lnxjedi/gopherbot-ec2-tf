#!/bin/bash

# bootstrap.sh - Turn an Amazon Linux 2 instance in to a Gopherbot host

export PATH=$PATH:/usr/local/bin
export AWS_REGION=$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq -r .region)

yum -y install jq git
amazon-linux-extras install -y ruby2.6
sudo yum -y remove awscli

# Install the latest awscli (v2)
cd /root
DEST=/tmp/awscli-exe-linux-x86.zip
wget -O $DEST https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
AWSCLI=$(mktemp -d awscli-XXXXX)
cd $AWSCLI
unzip $DEST
cd aws
cd /root
rm -rf $AWSCLI

# Install env-aws-params for GOPHERBOT_* env vars
EAP_LATEST=$(curl --silent https://api.github.com/repos/lnxjedi/env-aws-params/releases/latest | jq -r .tag_name)
curl -L -o /usr/local/bin/env-aws-params https://github.com/lnxjedi/env-aws-params/releases/download/$EAP_LATEST/env-aws-params_linux-amd64
chmod +x /usr/local/bin/env-aws-params

# Install latest Gopherbot
GBDL=/root/gopherbot.tar.gz
GB_LATEST=$(curl --silent https://api.github.com/repos/lnxjedi/gopherbot/releases/latest | jq -r .tag_name)
curl -L -o $GBDL https://github.com/lnxjedi/gopherbot/releases/download/$GB_LATEST/gopherbot-linux-amd64.tar.gz
cd /opt
tar xzvf $GBDL
rm $GBDL