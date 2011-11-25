# Class: graphite
#
# This module manages graphite
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
class graphite {

	include graphite::carbon
	include graphite::whisper
	include graphite::web

}


class graphite::web {

	     
	package {
		"bitmap-fonts":	
			ensure => present;
		"graphite-web":
			ensure => present;
	}



        service { 'httpd':
                ensure     => running,
                enable     => true,
                hasrestart => true,
                hasstatus  => true,
	}


}


class graphite::whisper {


	package {"whisper":
		ensure => present;
	}




}



class graphite::carbon {


	package {"carbon":
		ensure => present;
	}





    	service { 'carbon':
      		ensure     => running,
      		enable     => true,
      		hasrestart => true,
      		hasstatus  => true,
		require    => Package['carbon'],
    }


}

# needs to move to graphite::demo example and run example-client.py from the package   


class graphite::demo {


 exec { "startClientExample":
                command => "bash -c 'python /usr/share/doc/graphite-web-0.9.9/example-client.py >> /var/log/exampleclient.log' disown &",
                require => [ Class["graphite::web"], Class["graphite::carbon"],  Class["graphite::whisper"]],
                creates => "/var/log/exampleclient.log"
        }
}

