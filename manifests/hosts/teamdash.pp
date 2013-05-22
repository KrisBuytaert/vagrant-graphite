
node 'teamdash' {


  include my-repos
  #yumrepo { 'scl_ruby193':
  #  baseurl              => 'http://people.redhat.com/bkabrda/ruby193-rhel-6/',
  #  descr              => 'Ruby 1.9.3 Dynamic Software Collection',
  #  enabled          => '1',
  #  failovermethod => 'priority',
  #  gpgcheck     => '0',
  #}
  #package { 'ruby193':
  #  ensure => '1-6.el6',
  #}

  package { 'git':
    ensure => '1.7.1-2.el6_0.1',
  }
  package { 'libffi-devel':
    ensure => '3.0.5-3.2.el6',
  }
  package { 'libyaml-devel':
    ensure => '0.1.3-1.el6',
  }
  package { 'patch':
    ensure => '2.6-6.el6',
  }
  package { 'libxml2-devel':
    ensure => '2.7.6-8.el6_3.4',
  }
  package { 'mysql-devel':
    ensure => '5.1.67-1.el6_3',
  }
  package { 'gcc':
    ensure => '4.4.6-4.el6',
  }
  package { 'ruby-devel':
    ensure => '1.8.7.352-7.el6_2',
  }
  package { 'libxml2':
    ensure => '2.7.6-8.el6_3.4',
  }
  package { 'libxml2-devel':
    ensure => '2.7.6-8.el6_3.4',
  }
  package { 'libxslt':
    ensure => '1.1.26-2.el6_3.1',
  }
  package { 'libxslt-devel':
    ensure => '1.1.26-2.el6_3.1',
  }


}
