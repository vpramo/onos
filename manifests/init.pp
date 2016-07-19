class onos(
  $controllers_ip,
  $onos_home = '/opt/onos',
  $onos_pkg_url = 'http://192.168.122.217/onos.tar.gz',
  $onos_boot_features = 'config,standard,region,package,kar,ssh,management,webconsole,onos-api,onos-core,onos-incubator,onos-cli,onos-rest,onos-gui,onos-openflow-base,onos-openflow',
  $onos_extra_features = 'ovsdb,vtn',
  $karaf_dist = 'apache-karaf-3.0.5',
  $for_xos   = false
){

$ovs_manager_ip = $controllers_ip[0]
class {'::onos::install':}->
class {'::onos::config':}
if $for_xos {
class {'::onos::xos_service':
      controllers_ip => $controllers_ip}
Class['::onos::config'] -> Class['::onos::xos_service']
} else {

 class {'::onos::service':
      controllers_ip => $controllers_ip}
Class['::onos::config'] -> Class['::onos::service']
}


#class {'::onos::ovs':
#      manager_ip => $ovs_manager_ip}
}
