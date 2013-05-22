class my-gdash{


  include passenger

  file { '/var/vhosts/gdash/.htpasswd':
    content => 'inuits:HxSfFL52O7IDg',
    group   => '0',
    mode    => '644',
    owner   => '0',
  }

  apache::vhost{'gdash':
    docroot      => '/usr/local/gdash/public/',
    vhost_config => 'RackAutodetect On',
    diroptions   => '
    AuthUserFile /var/vhosts/gdash/.htpasswd
    AuthName EnterPassword
    AuthType Basic
    require user inuits',


  }

  class {'gdash':
    graphitehost => 'https://graphite.dev.inuits.eu/'
  }

  rsyslog::shiplog{'gdash-access':
    filename     => '/var/log/httpd/vhosts/gdash/access.log',
    inputfiletag => 'apache-access',
  }
  rsyslog::shiplog{'gdash-error':
    filename     => '/var/log/httpd/vhosts/gdash/error.log',
    inputfiletag => 'apache-error',
  }


}


