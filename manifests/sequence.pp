#
# @summary
#   A define for managing knockd sequences
#
# @param start_command
#   Command to run on successful knock.
#
# @param stop_command
#   Command to run automatically after successful knock after cmd_timeout
#   seconds
#
# @param sequence
#   port sequence to use
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
# @paramcommand
#   command executed on successful knock
#
# @param cmd_timeout
#   time to wait between start and stop command (only required in two knock mode).
#
define knockd::sequence (
  String           $start_command,
  String           $sequence,
  Integer          $seq_timeout = $knockd::params::seq_timeout,
  Integer          $cmd_timeout = $knockd::params::cmd_timeout,
  Optional[String] $stop_command = undef,
  Optional[String] $one_time_sequences = undef,
  Optional[String] $tcpflags = $knockd::params::tcpflags,
) {
  include knockd::params

  $epp_params = {
    'section'            => $title,
    'start_command'      => $start_command,
    'stop_command'       => $stop_command,
    'sequence'           => $sequence,
    'one_time_sequences' => $one_time_sequences,
    'tcpflags'           => $tcpflags,
    'seq_timeout'        => $seq_timeout,
    'cmd_timeout'        => $cmd_timeout,
  }

  concat::fragment { "knockd_conf_snippet_${title}":
    target  => $knockd::params::config_file,
    content => epp('knockd/knockd.conf-snippet.epp', $epp_params),
    order   => 10,
  }
}
