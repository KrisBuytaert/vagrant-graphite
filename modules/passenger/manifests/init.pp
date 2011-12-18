class passenger {
  # just in case apache is not included.

  # Package is avail be only for Red Hat CentOS 5 
  package{
    "rubygem-passenger": 
      #ensure => "2.2.2-2",
      ensure => installed,
      require => Package["httpd"],
      before => Service["httpd"];
    "mod_passenger":
      ensure  => installed,
      require => [Package['rubygem-passenger']];
  }

#  file{"/etc/httpd/conf.d/passenger.conf":
#    source => "puppet:///modules/passenger/passenger.conf",
#    mode => 644, 
#    owner=> root, 
#    group => root,
#    require => [Exec['generatePuppetKey'],Package['httpd']],
#[Exec['generatePuppetKey'],Package['httpd'],Package['rubygem-passenger'],File['/var/lib/puppet-server/ssl/certs/puppet.pem'],File['/var/lib/puppet-server/ssl/private_keys/puppet.pem'],File['/var/lib/puppet-server/ssl/ca/ca_crt.pem']],
#  }
}
