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
 $gdashroot = '/usr/local/gdash/'
 include passenger 
 package {"rubygem-sinatra": ensure => "1.3.1-1" }


 package {"rubygem-bundler": ensure => present }
 package {"rubygem-tilt":    ensure => "1.3.3-1" }
 package {"rubygem-rack":    ensure => "1.3.5-1" }
 package {"rubygem-rack-protection": ensure => "1.1.4-1" }




 package {"gdash": ensure => present }



 file {
	"/etc/httpd/conf.d/gdash.conf":
		ensure  => 'file',
		group   => '0',
		mode    => '644',
		owner   => '0',
		source => "puppet:///gdash/gdash.conf",
 		notify => Service['httpd'];
	"${gdashroot}/config/gdash.yaml": 
		source => "puppet:///gdash/gdash.yaml",
		group   => '0',
		owner   => '0';
}





} 

