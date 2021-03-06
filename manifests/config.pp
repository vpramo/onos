
class onos::config{
$onos_home = $onos::onos_home
$karaf_dist = $onos::karaf_dist
$onos_boot_features = $onos::onos_boot_features
$onos_extra_features = $onos::onos_extra_features
$controllers_ip = $onos::controllers_ip

notify { "controllers_ip is $controllers_ip":
  withpath => true
 }

file{ '/opt/onos_config.sh':
        source => "puppet:///modules/onos/onos_config.sh",
} ->
exec{ 'install onos config':
        command => "sudo sh /opt/onos_config.sh",
        path => "/usr/bin:/usr/sbin:/bin:/sbin",
        logoutput => "true",
}->
exec{ 'onos boot features':
        command => "sudo sed -i '/^featuresBoot=/c\featuresBoot=$onos_boot_features' $onos_home/$karaf_dist/etc/org.apache.karaf.features.cfg",
        path => "/usr/bin:/usr/sbin:/bin:/sbin",
        logoutput => "true",
}->
#file{ "${onos_home}/config/cluster.json":
#
#        ensure => file,
#        content => template('onos/cluster.json.erb')
#}
#
#file{ "${onos_home}/config/tablets.json":
#        ensure => file,
#        content => template('onos/tablets.json.erb'),
#}
case $::operatingsystem {
   ubuntu:{
        file{'/etc/init/onos.conf':
        ensure => file,
        content => template('onos/debian/onos.conf.erb')
}}
    centos:{
        file{'/etc/init.d/onos':
        ensure => file,
        content => template('onos/centos/onos.erb'),
        mode => 0777

}

}
}
}
