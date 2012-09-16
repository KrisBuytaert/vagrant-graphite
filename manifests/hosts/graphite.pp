

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


}

