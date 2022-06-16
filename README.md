# puppet-knockd

This module manages knockd.

# Examples

Open SSH port to any IP that provides the correct knock sequence, then close it
automatically after 30 seconds:

```
class { 'knockd':
  interface => $facts['networking']['primary'],
}

knockd::sequence { 'openCloseSSH':
  sequence      => '2222,3333,4444',
  seq_timeout   => 15,
  start_command => '/sbin/iptables -A INPUT -s %IP% -p tcp --dport ssh -j ACCEPT',
  cmd_timeout   => 30,
  stop_command  => '/sbin/iptables -D INPUT -s %IP% -p tcp --dport ssh -j ACCEPT',
}
```

The stop_command is not mandatory, but required for automatic cleanup. See class
documentation for additional options. Use two knockd::sequence resources
without a stop_command if you want one sequence to open a port, and another one to
close a port.

## Copyright

* Copyright 2015 Alessio Cassibba (X-Drum), unless otherwise noted.
* Copyright 2022 OpenVPN Inc.
