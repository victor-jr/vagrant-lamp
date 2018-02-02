exec { 'apt-get update': 
	command => '/usr/bin/apt-get update',
}

package { 'apache2': 
	ensure => present,
	require => Exec['apt-get update'],
}

package { 'php5-cli':
	ensure => present,
	require => Exec['apt-get update'],
}

package { 'php5-fpm':
	ensure => present,
	require => Exec['apt-get update'],
}

package { 'libapache2-mod-php5':
	ensure => present,
	require => Exec['apt-get update'],
}

service { 'apache2':
	ensure => running,
	require => Package['apache2'],
}

service { 'php5-fpm':
	ensure => running,
	require => Package['php5-fpm'],
}

file { 'vagrant-apache2':
	path => '/etc/apache2/sites-available/000-default.conf',
	ensure => file,
	require => Package['apache2'],
	source => 'puppet:///modules/apache2/000-default.conf',
}

# file { 'default-apache2-disable':
# 	path => '/etc/apache2/sites-enabled/default',
# 	ensure => absent,
# 	require => Package['apache2'],
# }

file { 'vagrant-apache2-enable':
	path => '/etc/apache2/sites-enabled/000-default.conf',
	target => '/etc/apache2/sites-available/000-default.conf',
	ensure => link,
	notify => Service['apache2'],
	require => [
		File['vagrant-apache2'],
		# File['default-apache2-disable'],
	],
}
