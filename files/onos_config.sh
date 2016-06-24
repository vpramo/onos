#!bin/bash
set -eux
sudo mkdir -p /opt/onos/config;
sudo echo 'export ONOS_OPTS=debug' > /opt/onos/options;
sudo echo 'export ONOS_USER=root' >> /opt/onos/options;
sudo rm -rf /opt/onos/var;
sudo mkdir /opt/onos/var;
