node 'dashing' {


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
}
