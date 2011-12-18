class passenger::ssl {
  #package { [ "mod_ssl" , "mod_authz_ldap" ]:
  package { 'mod_ssl':	
    ensure  => present, 
    require => Package['httpd'], 
    notify  => Exec["restart-httpd"]
  } 

  file {
    "/etc/httpd/conf.d/ssl.conf":
        source  => "puppet:///modules/passenger/ssl.conf",
        mode    => 0644, owner => root, group => root,
        require => Package['mod_ssl'],
	notify  => Exec["restart-httpd"];
    ["/var/cache/mod_ssl", "/var/cache/mod_ssl/scache"]:
        ensure  => directory,
        owner   => apache, 
        group   => root, 
        mode    => 0750,
	require => Package['httpd'],
        notify  => Exec['restart-httpd'];
  }
}
