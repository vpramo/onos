class onos::install{

  $onos_home = $onos::onos_home
  $onos_pkg_url = $onos::onos_pkg_url
  $karaf_dist = $onos::karaf_dist
  $onos_pkg_name = $onos::onos_pkg_name
  $jdk8_pkg_name = $onos::jdk8_pkg_name

  include apt
  group { 'onos':
        ensure => present,
        before => [ User['onos']],
  }


  user { 'onos':
        ensure     => present,
        home       => "$onos_home/",
        membership => 'minimum',
        groups     => 'onos',
  }



  Exec{
          path => "/usr/bin:/usr/sbin:/bin:/sbin",
          timeout => 180,
  }



  ::apt::ppa { 'ppa:webupd8team/java': }

  
  exec {'debconf1':
   command => 'echo debconf shared/accepted-oracle-license-v1-1 select true | sudo debconf-set-selections',
  }
  
  exec {'debconf2':
    command => 'echo debconf shared/accepted-oracle-license-v1-1 seen true | sudo debconf-set-selections',
  }

  $packages_oracle = ['oracle-java8-installer', 'oracle-java8-set-default']
  package { $packages_oracle:
     ensure => 'installed',
     require => [EXEC['debconf1'],EXEC['debconf2']]
  }


  file { '/opt/onos':
        ensure  => 'directory',
        recurse => true,
        owner   => 'onos',
        group   => 'onos',
        require => [Archive['onos'], Group['onos'], User['onos']],
  }


  archive { 'onos':
     ensure => present,
     url => "$onos_pkg_url",
     target => '/opt/onos',
     follow_redirects => true,
     checksum => false,
     #user       => 'onos',
     src_target => '/usr/src',
     require => [Group['onos'], User['onos']],
  }



}
