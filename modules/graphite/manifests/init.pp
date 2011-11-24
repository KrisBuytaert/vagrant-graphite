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

  	# REPLACE with package  
	     

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
















class graphite::whisper {

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
        	require => [ File['/opt/graphite/webapp/graphite/manage.py'], Package["python-fedora-django"] ]
        }
        file { "/opt/graphite/storage/graphite.db" :
               	owner => "apache",
               	mode => "0664",
		subscribe => Exec["init-db"],
		require => Package["httpd"]
       }


}



class graphite::carbon {

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
