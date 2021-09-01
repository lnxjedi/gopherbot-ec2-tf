#!/bin/bash

# bootstrap.sh - Turn an Amazon Linux 2 instance in to a Gopherbot host

yum -y update
yum -y install jq git
amazon-linux-extras install -y ruby2.6
sudo yum -y remove awscli

export PATH=$PATH:/usr/local/bin
export AWS_REGION=$(curl -s http://169.254.169.254/latest/meta-data/placement/region)
echo "Detected region: $AWS_REGION"
export INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
echo "Detected instance-id: $INSTANCE_ID"

# Install the latest awscli (v2)
cd /root
DEST=/tmp/awscli-exe-linux-x86.zip
curl -s -L -o $DEST https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip
AWSCLI=$(mktemp -d awscli-XXXXX)
cd $AWSCLI
unzip -q $DEST
cd aws
./install
cd /root
rm -rf $AWSCLI
aws --profile default configure set region $AWS_REGION

# Install env-aws-params for GOPHERBOT_* env vars
EAP_LATEST=$(curl --silent https://api.github.com/repos/lnxjedi/env-aws-params/releases/latest | jq -r .tag_name)
curl -s -L -o /usr/local/bin/env-aws-params https://github.com/lnxjedi/env-aws-params/releases/download/$EAP_LATEST/env-aws-params_linux-amd64
chmod +x /usr/local/bin/env-aws-params

# Install latest Gopherbot
GBDL=/root/gopherbot.tar.gz
GB_LATEST=$(curl --silent https://api.github.com/repos/lnxjedi/gopherbot/releases/latest | jq -r .tag_name)
curl -s -L -o $GBDL https://github.com/lnxjedi/gopherbot/releases/download/$GB_LATEST/gopherbot-linux-amd64.tar.gz
cd /opt
tar xzf $GBDL
rm $GBDL

BOT_NAME=$(aws ec2 describe-tags --filters Name=resource-type,Values=instance Name=resource-id,Values=$INSTANCE_ID | jq -r '.Tags[] | select(.Key == "robot-name").Value')
echo "Detected robot name: $BOT_NAME"
mkdir -p /var/lib/robots
useradd -d /var/lib/robots/$BOT_NAME -G wheel -r -m -c "$BOT_NAME gopherbot" $BOT_NAME
env-aws-params --silent -p /robots/$BOT_NAME --pristine $(which printenv) > /var/lib/robots/$BOT_NAME/.env
chown $BOT_NAME:$BOT_NAME /var/lib/robots/$BOT_NAME/.env
cat > /etc/systemd/system/$BOT_NAME.service <<EOF
[Unit]
Description=$BOT_NAME - Gopherbot DevOps Chatbot
Documentation=https://lnxjedi.github.io/gopherbot
After=syslog.target
After=network.target

[Service]
Type=simple
User=$BOT_NAME
Group=$BOT_NAME
WorkingDirectory=/var/lib/robots/$BOT_NAME
ExecStart=/opt/gopherbot/gopherbot -plainlog
Restart=on-failure
Environment=HOSTNAME=%H

KillMode=process
## Give the robot plenty of time to finish plugins currently executing;
## no new plugins will start after SIGTERM is caught.
TimeoutStopSec=600

[Install]
WantedBy=default.target
EOF

systemctl daemon-reload
systemctl enable $BOT_NAME
systemctl start $BOT_NAME
