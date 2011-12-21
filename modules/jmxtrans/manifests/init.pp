# Class: jmxtrans
#
# This module manages jmxtrans
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class jmxtrans {


  package {"jmxtrans": 
    ensure => present;} 
  service {"jmxtrans": 
    ensure => running; }

}

  class jmxtrans::example {

  file { '/var/lib/jmxtrans/localhost.json':
    group   => '0',
    mode    => '644',
    owner   => '0',
    source  => "puppet:///jmxtrans/localhost.json";
  }

}

