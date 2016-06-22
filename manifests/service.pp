class onos::service ($controllers_ip) {

Exec{
        path => "/usr/bin:/usr/sbin:/bin:/sbin",
        timeout => 360,
        logoutput => 'true',
}
#firewall {'215 onos':
#      port   => [ 6633, 6640, 6653, 8181, 8101,9876],
#      proto  => 'tcp',
#      action => 'accept',
#}->
exec{ 'start onos':
        command => 'service onos start',
        unless => 'service onos status | grep process'
}->

#service{ 'onos':
#        ensure => running,
#        enable => true,
#}->
exec{ 'sleep 100 to stablize onos':
        command => 'sudo sleep 100;'
}->

## create onos cluster
#if count($controllers_ip) > 1 {
#  $ip1 = $controllers_ip[0]
#  $ip2 = $controllers_ip[1]
#  $ip3 = $controllers_ip[2]
#  exec{ 'create onos cluster':
#        command => "/opt/onos/bin/onos-form-cluster $ip1 $ip2 $ip3"
#  }
#}
exec{ 'install openflow feature':
        command => "/opt/onos/bin/onos 'feature:install onos-openflow'"
}->
exec{ 'install openflow-base feature':
        command => "/opt/onos/bin/onos 'feature:install onos-openflow-base'"
}->
exec{ 'install onos-ovsdb-base feature':
        command => "/opt/onos/bin/onos 'feature:install onos-ovsdb-base'"
}->
exec{ 'install ovsdatabase feature':
        command => "/opt/onos/bin/onos 'feature:install onos-ovsdatabase'"
}->
exec{ 'install onos-ovsdb-provider-host feature':
        command => "/opt/onos/bin/onos 'feature:install onos-ovsdb-provider-host'"
}->
exec{ 'install onos-drivers-ovsdb feature':
        command => "/opt/onos/bin/onos 'feature:install onos-drivers-ovsdb'"
}->
exec{ 'sleep 10 to stablize onos features':
        command => 'sudo sleep 10;'
}->
exec{ 'install vtn feature':
        command => "/opt/onos/bin/onos 'feature:install onos-app-vtn-onosfw'"
}->
exec{ 'add onos auto start':
        command => 'sudo echo "onos">>/opt/service',
        logoutput => "true",
}-> 
exec{ 'set public port':
        command => "/opt/onos/bin/onos 'externalportname-set -n onos_port2'",
}
}
