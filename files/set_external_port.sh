#!bin/bash

ifconfig | grep onos_port

if [ $? -eq 1 ];then
  echo "ready to create onos_port"
  ip link add onos_port1 type veth peer name onos_port2
  ifconfig onos_port1 up
  ifconfig onos_port2 up

  external_port=$(ovs-vsctl list-ifaces br-ex);
  external_mac=$(ifconfig ${external_port} | \
                 grep -Eo "[0-9a-f\]+:[0-9a-f\]+:[0-9a-f\]+:[0-9a-f\]+:[0-9a-f\]+:[0-9a-f\]+")

  ifconfig onos_port2 hw ether ${external_mac}
  ovs-vsctl add-port br-ex onos_port1
else
  echo "onos_port already exist"

fi
