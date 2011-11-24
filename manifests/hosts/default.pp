


$build_dir = "/vagrant/files/"
$version = "-0.9.9"



	yumrepo {


		'epel':
			baseurl => $operatingsystemrelease ? {
				'6.0' => "http://mirror.eurid.eu/epel/6/$hardwaremodel/",
					'*' => "http://mirror.eurid.eu/epel/5/$hardwaremodel/",
			},
				descr => $operatingsystemrelease ? {
					'6.0' => 'Extra Packages for Enterprise Linux 6.x
						',
					'*' => 'Extra Packages for Enterprise Linux 5.x',
				},
				gpgcheck => 0,
				enabled => 1;


		'inuits':
			baseurl => $operatingsystemrelease ? {
				'6.0' => 'http://repo.inuits.be/centos/6/os',
					'*' => 'http://repo.inuits.be/centos/5/os',
			},
				descr => $operatingsystemrelease ? {
					'6.0' => 'inuits CentOS 6.x repo',
					'*' => 'inuits CentOS 5.x repo',
				},
				gpgcheck => 0,
				enabled => 1;


	}




package {"django-tagging": 
	ensure => present;
}








class client_demo{
	exec { "startClientExample":
		command => "bash -c 'python /vagrant/files/graphite-web-0.9.9/examples/example-client.py >> /var/log/exampleclient.log' disown &",
		require => [ Class["graphite::web"], Class["graphite::carbon"],  Class["graphite::whisper"]],
		creates => "/var/log/exampleclient.log"
	}
}



#Global
Package { ensure => "installed" }
Exec { path => ["/usr/bin", "/usr/sbin", "/bin"] }


$soft = [ "httpd", "mod_wsgi", "python-fedora-django", "mod_python", "python-zope-interface", "python-twisted-core", "python-memcached", "python-ldap" ]
package { $soft: }


include graphite::web
include client_demo


#Do not use a notify or a subscribe to trigger this service, by default the service always will be restarted
#In this case we want the service to be stopped, so we need to use a require or before metaparameter
#Stop iptables
service { 'iptables':
	name      => "iptables",
        ensure    => "stopped",
        enable    => false,
        require => Class['graphite::web'],
        hasstatus => "true" #This is needed, otherwise puppet will look at the process table to check if the process name is running. Iptables does not have a process as sits in the kernel
}

file { '/etc/localtime':
       	ensure => "/usr/share/zoneinfo/Europe/Brussels",
	before => Class["graphite::whisper"]
}


