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
  String           $sequence = $knockd::params::sequence,
  String           $one_time_sequences = $knockd::params::one_time_sequences,
  Integer          $seq_timeout = $knockd::params::seq_timeout,
  String           $tcpflags = $knockd::params::tcpflags,
  String           $start_command = $knockd::params::start_command,
  String           $stop_command = $knockd::params::stop_command,
  Integer          $cmd_timeout = $knockd::params::cmd_timeout,
  Optional[String] $open_sequence = $knockd::params::open_sequence,
  Optional[String] $close_sequence = $knockd::params::close_sequence,
) {
  include knockd::params

  if (($open_sequence) and (!$close_sequence)) or (($close_sequence) and (!$open_sequence)) {
    fail("ERROR: both \$open_sequence and \$close_sequence must be defined, or not defined at all!")
  }

  concat::fragment { "knockd_conf_snippet_${title}":
    target  => $knockd::params::config_file,
    content => template('knockd/knockd.conf-snippet.erb'),
    order   => 10,
  }
}
