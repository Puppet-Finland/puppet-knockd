#
# @summary
#   A class for managing knockd configuration.
#
class knockd::params {
  $package_ensure = 'present'
  $service_name = 'knockd'
  $usesyslog = false
  $logfile = '/var/log/knockd.log'
  $pidfile = '/var/run/knockd.pid'
  $interface = undef
  $seq_timeout = undef
  $tcpflags = undef
  $cmd_timeout = undef

  case $facts['kernel'] {
    'FreeBSD': {
      $config_file = '/usr/local/etc/knockd.conf'
      $default_owner = 'root'
      $default_group = 'wheel'
      $package_name = 'knock'
    }
    'Linux',default: {
      $config_file = '/etc/knockd.conf'
      $default_owner = 'root'
      $default_group = 'root'
      $package_name = 'knockd'
    }
  }
}
