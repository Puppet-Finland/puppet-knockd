#
# @summary
#   A define for managing knockd sequences
#
# @param sequence
#   port sequence used in single knock mode.
#
# @param open_sequence
#   port sequence used in the open knock (two knock mode).
#
# @param close_sequence
#   port sequence used in the close knock (two knock mode).
#
# @param one_time_sequences
#   file containing the one time sequences to be used. (instead of using a fixed sequence).
#
# @param seq_timeout
#   port sequence timeout.
#
# @param tcpflags
#   only pay attention to packets that have this flag set.
#
# @param start_command
#   command executed when a client makes a correct port knock (both modes).
#
# @param stop_command
#   command executed when cmd_timeout seconds are passed or when a close sequence was received (both modes).
#
# @param cmd_timeout
#   time to wait between start and stop command (only required in two knock mode).
#
define knockd::sequence (
  $sequence = $knockd::params::sequence,
  $open_sequence = $knockd::params::open_sequence,
  $close_sequence = $knockd::params::close_sequence,
  $one_time_sequences = $knockd::params::one_time_sequences,
  $seq_timeout = $knockd::params::seq_timeout,
  $tcpflags = $knockd::params::tcpflags,
  $start_command = $knockd::params::start_command,
  $stop_command = $knockd::params::stop_command,
  $cmd_timeout = $knockd::params::cmd_timeout,
) {
  include knockd::params

  if $sequence == undef {
    err('Please specify a valid value for sequence.')
  }
  if $seq_timeout == undef {
    err('Please specify a valid value for timeout')
  }
  if $tcpflags == undef {
    err('Please specify a valid value for tcpflags.')
  }

  if $sequence {
    if ($start_command == undef) or ($stop_command == undef) {
      err('Please specify a valid value for both start_command and stop_command.')
    }
    if $cmd_timeout == undef {
      err('Please specify a valid value for sequence.')
    }
  }
  else {
    err('Please specify a valid value for sequence.')
  }

  if ($open_sequence) and ($close_sequence) {
    if ($start_command == undef) or ($stop_command == undef) {
      err('Please specify a valid value for command.')
    }
  }
  else {
    err('Please specify a valid value for both open_sequence and close_sequence.')
  }

  concat::fragment { "knockd_conf_snippet_${title}":
    target  => $knockd::params::config_file,
    content => template('knockd/knockd.conf-snippet.erb'),
    order   => 10,
  }
}
