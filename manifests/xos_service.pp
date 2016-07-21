class onos::xos_service ($controllers_ip,
                         $cluster_form = false,
                 ) {

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
}-> 


exec{ 'app install openflow-base feature':
        command => "/opt/onos/bin/onos 'app activate org.onosproject.openflow-base'",
        before => EXEC['create onos cluster'],
}->
exec{ 'stabalize features':
        command => "sudo sleep 30",
        before => EXEC['create onos cluster']
}



if ($::onos_run == "true") {
  if ($::hostname =='onos-xos-ctrl1') {
    if count($controllers_ip) > 1 {
      if $cluster_form {
      $ip1 = $controllers_ip[0]
      $ip2 = $controllers_ip[1]
      $ip3 = $controllers_ip[2]
      exec{ 'create onos cluster':
           command => "/opt/onos/bin/onos-form-cluster $ip1  $ip2  $ip3",
            creates => '/opt/onos/config/cluster.json'
      }
     }
      else {
      exec{ 'create onos cluster':
           command => "date",
      }
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

