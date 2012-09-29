

node 'default' {


  include my-repos
  include my-graphite
  include apache
  #  apache::listen{'80':}
  #  apache::namevhost{'80':}
  include passenger

  apache::vhost{'gdash':
    docroot      => '/usr/local/gdash/public/',
    vhost_config =>'
    RackAutodetect On',
  }

  class {'gdash':
    graphitehost => 'https://graphite.dev.inuits.eu/'
  }

  tmpwatch::cleanup {'jmxtrans':
    path => '/var/lib/jmxtrans',
    age  => '5d',
  }
  tmpwatch::cleanup {'carbon':
    path => '/var/lib/carbon',
    age  => '5d',
  }

  class {'rsyslog':
    servers => '10.42.42.51';
  }
  class {'rsyslog::filelog':}
  rsyslog::shiplog{'gdash-access':
    filename => '/var/log/httpd/vhosts/gdash/access.log',
    inputfiletag => 'apache-access',
  }
  rsyslog::shiplog{'gdash-error':
    filename => '/var/log/httpd/vhosts/gdash/error.log',
    inputfiletag => 'apache-error',
  }

}

