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

 # package {"bundler": ensure => 


 # Build rpmn 's for .. include them in repo 
 # bundler
 # rack 1.3.4
 # rack-protecion 1.1.4 
 # tilt 1.3.3
 # sinatra 1.3.1 



 file {
	"/etc/httpd/conf.d/gdash.conf":
		ensure  => 'file',
		group   => '0',
		mode    => '644',
		owner   => '0',
		source => "puppet:///gdash/gdash.conf",
 		notify => Service['httpd'];
	"/vagrant/other/gdash/config/gdash.yaml": 
		source => "puppet:///gdash/gdash.yaml",
		group   => '0',
		owner   => '0';
}

# Introduce  siteroot variable for this .
# Probably package gDash too :) 




} 

