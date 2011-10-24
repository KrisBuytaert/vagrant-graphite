$build_dir = "/vagrant/files/"
$version = "-0.9.9"


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



class carbon {

        $class = "carbon"
        $dir = "$class$version"

        #extract

        exec { "extract$dir":
        	command => "tar -xvzf $dir.tar.gz",
	        cwd => "$build_dir",
        	creates => "$build_dir/$dir", #If this file exist, this exec will not get executed anymore
		require => [ Package["python-twisted-core"], Package["python-zope-interface"] ],
        }

        #install
       	exec { "install$dir":
        	command => "python setup.py install",
	        cwd => "$build_dir/$dir",
        	require => Exec["extract$dir"],
        	creates => "/opt/graphite/bin/carbon-cache.py",
        }

        #default config /opt/graphite/conf/carbon.conf
        file { "/opt/graphite/conf/carbon.conf":
                #replace => "yes",
                source => "/opt/graphite/conf/carbon.conf.example",
                ensure => "present",
                require => Exec["install$dir"],
        }

        file { "/opt/graphite/conf/storage-schemas.conf":
                #replace => "yes",
                source => "/opt/graphite/conf/storage-schemas.conf.example",
                ensure => "present",
                require => Exec["install$dir"],
        }
        file { '/etc/init.d/carbon':
    		ensure => present,
		mode   => 755,
		source => "$build_dir/carbon_init",
      		owner => 'root',
      		group => 'root',
    	}

    	service { 'carbon':
      		ensure     => running,
      		enable     => true,
      		hasrestart => true,
      		hasstatus  => true,
		subscribe => [ File["/opt/graphite/conf/carbon.conf"],File["/opt/graphite/conf/storage-schemas.conf"]],
		require => [File["/opt/graphite/conf/storage-schemas.conf"],File["/opt/graphite/conf/carbon.conf"],File["/etc/init.d/carbon"]]
    }


}


class whisper {

        $class = "whisper"
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
        	creates => "/usr/bin/whisper-create.py",
        }
        
	#Init DB
       	exec { "init-db":
        	command => "python manage.py syncdb --noinput",
        	cwd => "/opt/graphite/webapp/graphite",
        	creates => "/opt/graphite/storage/graphite.db",
        	require => [ File['/opt/graphite/webapp/graphite/manage.py'], Package["python-fedora-django"],Exec["installdjango-tagging-0.3.1"] ]
        }
        file { "/opt/graphite/storage/graphite.db" :
               	owner => "apache",
               	mode => "0664",
		subscribe => Exec["init-db"],
		require => Package["httpd"]
       }


}

class graphite-web {

        include carbon
        include whisper
	include django-tagging

        $class = "graphite-web"
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
        	creates => "/opt/graphite/webapp",
        }
	
	#Following files needs to be executable
        file { '/opt/graphite/webapp/graphite/manage.py':
            ensure => file,
                mode   => 755,
                #owner => 'apache',
                #group => 'apache',
		require => Exec["install$dir"],
        }


	####Configurations changes needed to support apache webserver

        file { '/etc/httpd/conf.d/graphite.conf':
                ensure => present,
                mode   => 644,
                source => "$build_dir/graphite_conf_apache",
                owner => 'root',
                group => 'root',
		require => Package["httpd"] #for the user apache
        }
	file { '/etc/httpd/conf.d/wsgi.conf':
                ensure => present,
                mode   => 644,
                source => "$build_dir/wsgi_conf_apache",
                owner => 'root',
                group => 'root',
		require => Package["httpd"] #for the user apache
        }
	file { "/opt/graphite/storage":
    		ensure => "directory",
    		owner => "apache",
    		mode => "0775",
    		#subscribe => Exec["install$dir"],
		recurse => true,
		require => [Package["httpd"], Exec["install$dir"]] #for the user apache
	  }		
        #file { "/opt/graphite/webapp/graphite/local_settings.py":
         #       ensure => "file",
	#	content => "
	#	TIME_ZONE = 'Europe/Amsterdam'
	#	",
        #        owner => "apache",
        #        require => [Exec["install$dir"],Package["httpd"],Exec["init-db"]]
        #  }

	
        file { "/opt/graphite/conf/graphite.wsgi":
                source => "/opt/graphite/conf/graphite.wsgi.example",
                ensure => "present",
		 owner => "apache",
		 require => [Exec["install$dir"],Package["httpd"]]
        }

        service { 'httpd':
                ensure     => running,
                enable     => true,
                hasrestart => true,
                hasstatus  => true,
                subscribe  => [ File['/etc/httpd/conf.d/wsgi.conf'],File['/etc/httpd/conf.d/graphite.conf']],
                #subscribe  => [ File['/etc/httpd/conf.d/wsgi.conf'],File['/etc/httpd/conf.d/graphite.conf'],File['/opt/graphite/webapp/graphite/local_settings.py']],
		require => [ File["/opt/graphite/storage"], File["/opt/graphite/storage/graphite.db"], Package["mod_wsgi"]],
	}


}

class client_demo{
	exec { "startClientExample":
		command => "bash -c 'python /vagrant/files/graphite-web-0.9.9/examples/example-client.py >> /var/log/exampleclient.log' disown &",
		require => [ Class["graphite-web"], Class["carbon"], Class["django-tagging"], Class["whisper"]],
		creates => "/var/log/exampleclient.log"
	}
}

class disableselinux {
	#temporary
	exec { "stopselinux":
        	command => "/usr/sbin/setenforce 0",
	        notify => Service['httpd'],
	}

	#permanent
	augeas { "selinux":
 		context => "/files/etc/sysconfig/selinux/",
    		changes => [ "set SELINUX disabled" ],
	}
}


#Global
Package { ensure => "installed" }
Exec { path => ["/usr/bin", "/usr/sbin", "/bin"] }


$soft = [ "httpd", "mod_wsgi", "python-fedora-django", "mod_python", "python-zope-interface", "python-twisted-core", "python-memcached", "python-ldap" ]
package { $soft: }



include graphite-web
include disableselinux
include client_demo


#Do not use a notify or a subscribe to trigger this service, by default the service always will be restarted
#In this case we want the service to be stopped, so we need to use a require or before metaparameter
#Stop iptables
service { 'iptables':
	name      => "iptables",
        ensure    => "stopped",
        enable    => false,
        require => Class['graphite-web'],
        hasstatus => "true" #This is needed, otherwise puppet will look at the process table to check if the process name is running. Iptables does not have a process as sits in the kernel
}

file { '/etc/localtime':
       	ensure => "/usr/share/zoneinfo/Europe/Brussels",
	before => Class["whisper"]
}

