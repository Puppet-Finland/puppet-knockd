# @summary
#   A class for managing knockd configuration.
#
# @param package_name
#   package name.
#
# @param package_ensure
#   status of the package
#
# @param service_name
#   service name (initscript name).
#
# @param config_file
#   location of the knockd configuration file.
#
# @param usesyslog
#   log action messages through syslog().
#
# @param logfile
#   log actions directly to a file, (defaults to: /var/log/knockd.log).
#
# @param pidfile
#   pidfile to use when in daemon mode, (defaults to: /var/run/knockd.pid).
#
# @param interface
#   network interface to listen on (mandatory).
#
class knockd (
  Enum['present','absent'] $package_ensure = $knockd::params::package_ensure,
  String                   $package_name = $knockd::params::package_name,
  String                   $service_name = $knockd::params::service_name,
  Stdlib::Absolutepath     $config_file  = $knockd::params::config_file,
  Boolean                  $usesyslog    = $knockd::params::usesyslog,
  Stdlib::Absolutepath     $logfile      = $knockd::params::logfile,
  Stdlib::Absolutepath     $pidfile      = $knockd::params::pidfile,
  String                   $interface    = $knockd::params::interface,
) inherits knockd::params {
  if $facts['os']['family'] == 'Debian' {
    file { '/etc/default/knockd':
      ensure  => file,
      owner   => $knockd::params::default_owner,
      group   => $knockd::params::default_group,
      mode    => '0644',
      content => "START_KNOCKD=1\n",
    }
  }

  package { $knockd::params::package_name:
    ensure => $package_ensure,
  }

  concat { $knockd::params::config_file:
    owner => $knockd::params::default_owner,
    group => $knockd::params::default_group,
    mode  => '0740',
  }
  concat::fragment { 'knockd_config_header':
    target  => $knockd::params::config_file,
    content => template('knockd/knockd.conf.erb'),
    order   => '00',
  }
  concat::fragment { 'knockd_config_footer':
    target  => $knockd::params::config_file,
    content => '',
    order   => '99',
  }

  service { $knockd::params::service_name:
    ensure     => 'running',
    enable     => true,
    hasstatus  => false,
    hasrestart => true,
    subscribe  => Concat[$knockd::params::config_file],
    require    => [Package[$knockd::params::package_name], Concat[$knockd::params::config_file]],
  }
}
