class onos::service ($controllers_ip,
                     $install_features=false,) {

Exec{
        path => "/usr/bin:/usr/sbin:/bin:/sbin",
        timeout => 360,
        logoutput => 'true',
}
exec{ 'start onos':
        command => 'service onos start',
        unless => 'service onos status | grep process'
}->

exec{ 'sleep 100 to stablize onos':
        command => 'sudo sleep 100;'
} ->

exec{ 'app install openflow-base feature':
        command => "/opt/onos/bin/onos 'app activate org.onosproject.openflow-base'",
        before => EXEC['create onos cluster']
}

if $install_features {
exec{ 'install openflow feature':
        command => "/opt/onos/bin/onos 'feature:install onos-openflow'",
        before => EXEC['create onos cluster']
}->
exec{ 'install openflow-base feature':
        command => "/opt/onos/bin/onos 'feature:install onos-openflow-base'",
        before => EXEC['create onos cluster']
}->
exec{ 'install onos-ovsdb-base feature':
        command => "/opt/onos/bin/onos 'feature:install onos-ovsdb-base'",
        before => EXEC['create onos cluster']
}->
exec{ 'install ovsdatabase feature':
        command => "/opt/onos/bin/onos 'feature:install onos-ovsdatabase'",
        before => EXEC['create onos cluster']
}->
exec{ 'install onos-ovsdb-provider-host feature':
        command => "/opt/onos/bin/onos 'feature:install onos-ovsdb-provider-host'",
        before => EXEC['create onos cluster']
}->
exec{ 'install onos-drivers-ovsdb feature':
        command => "/opt/onos/bin/onos 'feature:install onos-drivers-ovsdb'",
        before => EXEC['create onos cluster']
}->
exec{ 'sleep 10 to stablize onos features':
        command => 'sudo sleep 10;'
}->
exec{ 'install vtn feature':
        command => "/opt/onos/bin/onos 'feature:install onos-app-vtn-onosfw'",
        before => EXEC['create onos cluster']
}->
exec{ 'add onos auto start':
        command => 'sudo echo "onos">>/opt/service',
        logoutput => "true",
}-> 
exec{ 'set public port':
        command => "/opt/onos/bin/onos 'externalportname-set -n onos_port2'",
        before => EXEC['create onos cluster']
}->
exec{ 'stabalize features':
        command => "sudo sleep 30",
        before => EXEC['create onos cluster']
}

}
if ($::onos_run == "true") {
  if ($::hostname =='onos-ctrl1') {
    if count($controllers_ip) > 1 {
      $ip1 = $controllers_ip[0]
      $ip2 = $controllers_ip[1]
      $ip3 = $controllers_ip[2]
      exec{ 'create onos cluster':
           command => "/opt/onos/bin/onos-form-cluster $ip1  $ip2  $ip3",
            creates => '/opt/onos/config/cluster.json'
      }
    }else {
      exec{ 'create onos cluster':
           command => "date",
      }
   }
  }else{
  exec{ 'create onos cluster':
           command => "date",
      }

  }

  }else{
  
   notify{$::onos_run:}
  }



}

