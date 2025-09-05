#!/bin/bash
set -e
if [ "$(id -u)" -ne 0 ]; then
  echo "Run as root"
  exit 1
fi

echo "Installing Puppet agent..."
curl -O https://apt.puppet.com/puppet7-release-focal.deb
dpkg -i puppet7-release-focal.deb || apt-get -f install -y
apt-get update
apt-get install -y puppet-agent
systemctl enable puppet
systemctl start puppet
