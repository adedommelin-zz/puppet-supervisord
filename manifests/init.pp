# == Class: supervisord
#
# Manage supervisord
#
# === Examples
#
#  class { supervisord: }
#
# === Authors
#
# Alexandre De Dommelin <adedommelin@tuxz.net>
#
# === Copyright
#
# Copyright 2013 Alexandre De Dommelin
#
class supervisord {
  package { 'supervisor':
    ensure => present
  }

  case $::operatingsystem {
    centos: {
      $supervisord_config = '/etc/supervisord.conf'
    }
    redhat: {
      $supervisord_config = '/etc/supervisord.conf'
    }
    debian: {
      $supervisord_config = '/etc/supervisor/supervisord.conf'
    }
    default: {
      fail("Module ${module_name} is not supported on ${::operatingsystem}")
    }
  }

  File {
    owner => 'root',
    group => 'root',
    mode  => '0644'
  }

  file { '/etc/supervisord':
    ensure  => 'directory',
  } -> file { '/etc/supervisord/conf.d':
    ensure  => 'directory'
  } -> file { $supervisord_config:
    source  => 'puppet:///supervisord/supervisord.conf',
    owner   => 'root',
    group   => 'root',
    mode    => '0644'
  } -> service { 'supervisor':
    ensure  => 'running',
    enable  => true,
    require => Package['supervisor']
  }
}
