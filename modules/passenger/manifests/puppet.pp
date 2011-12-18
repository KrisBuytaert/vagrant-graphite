class passenger::puppet {

include passenger::ssl

package  { "rubygem-rack":
		ensure => installed ;
	"puppet-server":
		ensure => installed;
}

service { "puppetmaster":
	ensure  => stopped,
	enable => false;
}

exec { 'generatePuppetKey':
	command     => 'service puppetmaster start; service puppetmaster stop',
	creates     => '/var/lib/puppet-server/ssl/private_keys/puppet.pem',
	path        => ['/usr/sbin','/usr/bin','/bin','/sbin'],
        #notify      => Exec["restart-httpd"],
	require     => [Package['puppet-server'],File['/var/lib/puppet-server/']],
	#refreshonly => 'true',
}


file {
	'/var/lib/puppet-server/':
		ensure => directory,
		owner  => puppet;
  '/var/lib/puppet-server/ssl/certs/puppet.pem':
    #ensure => present,
    require => Exec['generatePuppetKey'];
  '/var/lib/puppet-server/ssl/private_keys/puppet.pem':
    #ensure => present,
    require => Exec['generatePuppetKey'];
  '/var/lib/puppet-server/ssl/ca/ca_crt.pem':
    #ensure => present,
    require => Exec['generatePuppetKey'];
	"/etc/httpd/conf.d/puppetmaster.conf":
		source  => "puppet:///modules/passenger/puppetmaster.conf",
		#require => [Package['httpd'],File['/etc/httpd/conf.d/passenger.conf']],	
		require => [Package['httpd'],Package['mod_passenger'],Exec['generatePuppetKey']],
		notify  => Exec["restart-httpd"];
	"/usr/share/puppet/rack":
		ensure => directory;
	"/usr/share/puppet/rack/puppetmasterd":
		ensure => directory;
	"/usr/share/puppet/rack/puppetmasterd/public": 
		ensure => directory;
	"/usr/share/puppet/rack/puppetmasterd/tmp":
		ensure => directory;
	"/usr/share/puppet/rack/puppetmasterd/config.ru":
		source => "/usr/share/puppet/ext/rack/files/config.ru",
		owner => puppet;
	}



}
