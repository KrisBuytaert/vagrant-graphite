

node 'default' {


  include my-repos
  include my-graphite
  include apache
  apache::listen{'80':}
  apache::namevhost{'80':}
  include passenger
  class {'gdash':
    graphitehost => '10.42.42.13'
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

