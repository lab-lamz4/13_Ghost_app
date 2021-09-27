#!/bin/bash -xe
export HOME="/root"
GHOST_PACKAGE="ghost-4.12.1.tgz"

### Install pre-reqs
curl https://bootstrap.pypa.io/get-pip.py -o /tmp/get-pip.py
sudo python3 /tmp/get-pip.py
sudo /usr/local/bin/pip install botocore
curl -sL https://rpm.nodesource.com/setup_14.x | sudo bash -
sudo yum install -y nodejs
sudo npm install pm2 -g

### EFS
mkdir -p /var/lib/ghost/content
yum -y install amazon-efs-utils

### Configure and start ghost app
mkdir ghost
wget https://registry.npmjs.org/ghost/-/$GHOST_PACKAGE
tar -xzvf $GHOST_PACKAGE -C ghost --strip-components=1
rm $GHOST_PACKAGE && cd ghost
