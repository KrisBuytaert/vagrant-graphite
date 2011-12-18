# Class: gdash
#
# This module manages gdash
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
class gdash {

 include passenger 
 package {"rubygem-sinatra": ensure => present }


 file {"/etc/httpd/conf.d/gdash.conf":
  ensure  => 'file',
  group   => '0',
  mode    => '644',
  owner   => '0',
  source => "puppet:///gdash/gdash.conf",
  notify => Service['httpd'];
}




}

