class my-repos{


  yumrepo { 'rubygems':
    baseurl    => 'http://pulp.inuits.eu/pulp/repos/rubygems',
    descr      => 'RubyGems at Inuits',
    gpgcheck   => '0',
  }

  yumrepo { 'monitoringsucks':
    baseurl    => 'http://pulp.inuits.eu/pulp/repos/monitoring',
    descr      => 'MonitoringSuck at Inuits',
    gpgcheck   => '0',
  }
  yumrepo {'epel':
    baseurl    => 'http://pulp.inuits.eu/pulp/repos/epel/6/x86_64/',
    descr      => 'Epel Repo at Inuits',
    gpgcheck   => '0',
  }
  yumrepo {'nodjes-tchol':
    baseurl    => 'https://pulp.inuits.eu/pulp/repos/stable/el6/x86_64/',
    descr      => 'NodeJs Tjol Mirror at Inuits',
    gpgcheck   => '0',
  }

}
