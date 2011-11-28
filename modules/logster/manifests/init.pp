# Class: logster
#
# This module manages logster
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
class logster {


	package { "logster":  
			ensure => present;
		  "logcheck":
			ensure => present;
	}


}

define logster::graphite ($host = '',$type ='SampleLogster',$file,$prefix) {



  	cron { "cron-$prefix":
                        ensure  => present,
                        command => "/usr/sbin/logster --output=graphite --graphite-host=$host:2003 $type $file -p $prefix  > /dev/null 2>&1",
                        user    => 'root',
                        minute  => '*',
                }



}





