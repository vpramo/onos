#!bin/bash
set -eux

sudo echo 'export ONOS_OPTS=debug' > /opt/onos/options;
sudo echo 'export ONOS_USER=root' >> /opt/onos/options;
sudo rm -rf /opt/onos/var;
sudo rm -rf /opt/onos/config;
sudo mkdir /opt/onos/var;
sudo mkdir /opt/onos/config;
