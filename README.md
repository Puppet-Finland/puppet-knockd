puppet-knockd
==========

This module manages knockd.

## Examples

```
 class { "knockd":
   interface => 'eth0',
 }
```

> An Open/Close example that uses a single knock to control access to port 22(ssh):
```
 class { "knockd":
   interface => 'eth3',
 }
 knockd::sequence {
   "SSH":
     sequence      => '2222:udp,3333:tcp,4444:udp',
     seq_timeout   => '15',
     tcpflags      => 'syn,ack',
     start_command => '/usr/sbin/iptables -A INPUT -s %IP% -p tcp --syn --dport 22 -j ACCEPT',
     cmd_timeout   => '10',
     stop_command  => '/usr/sbin/iptables -D INPUT -s %IP% -p tcp --syn --dport 22 -j ACCEPT',
 }
```
> An example using two knocks: the first allow access to port 22(ssh), the second will close the port:
```
 class { "knockd":
   interface => 'eth0',
 }
 knockd::sequence {
   "SSH":
     open_sequence      => '7000,8000,9000',
     close_sequence     => '9000,8000,7000',
     seq_timeout        => '10',
     tcpflags           => 'syn',
     start_command      => '/usr/sbin/iptables -A INPUT -s %IP% -p tcp --syn --dport 22 -j ACCEPT',
     stop_command       => '/usr/sbin/iptables -D INPUT -s %IP% -p tcp --syn --dport 22 -j ACCEPT',
  }
```

### Copyright:
Copyright 2015 Alessio Cassibba (X-Drum), unless otherwise noted.
