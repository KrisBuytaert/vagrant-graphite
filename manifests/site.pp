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

	}

class django-tagging {

        $class = "django-tagging"
        $version = "-0.3.1"
        $dir = "$class$version"

        #extract

        exec { "extract$dir":
        	command => "tar -xvzf $dir.tar.gz",
	        cwd => "$build_dir",
        	creates => "$build_dir/$dir", #If this file exist, this exec will not get executed anymore
        }

        #install
        exec { "install$dir":
	        command => "python setup.py install",
        	cwd => "$build_dir/$dir",
	        require => Exec["extract$dir"],
	        creates => "/usr/lib/python2.7/site-packages/tagging/managers.py",
        }

}








class client_demo{
	exec { "startClientExample":
		command => "bash -c 'python /vagrant/files/graphite-web-0.9.9/examples/example-client.py >> /var/log/exampleclient.log' disown &",
		require => [ Class["graphite::web"], Class["graphite::carbon"], Class["django-tagging"], Class["graphite::whisper"]],
		creates => "/var/log/exampleclient.log"
	}
}



#Global
Package { ensure => "installed" }
Exec { path => ["/usr/bin", "/usr/sbin", "/bin"] }


$soft = [ "httpd", "mod_wsgi", "python-fedora-django", "mod_python", "python-zope-interface", "python-twisted-core", "python-memcached", "python-ldap" ]
package { $soft: }


include django-tagging
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

