# @summary Manage Sendmail Milter configuration in sendmail.mc
#
# @example Add the `greylist` milter using a local socket
#   sendmail::mc::milter { 'greylist':
#     socket_type => 'local',
#     socket_spec => '/var/run/milter-greylist/milter-greylist.sock',
#   }
#
# @example Add the `greylist` milter using a TCP/IP socket
#   sendmail::mc::milter { 'greylist':
#     socket_type => 'inet',
#     socket_spec => '12345@192.168.0.42',
#   }
#
# @param socket_type The type of socket to use for connecting to the milter.
#   Valid values: `local`, `unix`, `inet`, `inet6`
#
# @param socket_spec The socket specification for connecting to the milter.
#   For the type `local` (`unix` is a synonym) this is the full path to the
#   Unix-domain socket.  For the `inet` and `inet6` type socket this must be
#   the port number, a literal `@` character and the host or address
#   specification.
#
# @param flags Either the empty string or a single character to specify how
#   milter failures are handled by Sendmail.  The letter `R` rejects the
#   message, a `T` causes a temporary failure and the character `4`
#   (available with Sendmail V8.4 or later) rejects with a 421 response code.
#   If the empty string is used, Sendmail will treat a milter failure as if
#   the milter wasn't configured.
#
# @param send_timeout Timeout when sending data from the MTA to the Milter.
#   The default is undefined (using the Sendmail default 10sec).
#
# @param receive_timeout Timeout when reading a reply from the Milter.  The
#   default is undefined (using the Sendmail default 10sec).
#
# @param eom_timeout Overall timeout from sending the messag to Milter until
#   the final end of message reply is received.  The default is undefined
#   (using the Sendmail default 5min).
#
# @param connect_timeout Connection timeout. The default value is undefined
#   (using the Sendmail default 5min).
#
# @param order A string used to determine the order of the mail filters in
#   the configuration file.  This also defines the order in which the filters
#   are called.
#
# @param milter_name The name of the milter to create.
#
# @param enable A boolean to indicate if the milter should automatically be
#   enabled.  If this is `true` (the default) then the milter will be called
#   by Sendmail for every incoming mail.  If this is set to `false` then the
#   milter is only defined.  It needs to be enabled by either setting the
#   parameter `input_filter` for `sendmail::mc::daemon_options` or defining
#   `confINPUT_MAIL_FILTERS`.  Internally this parameter determines if the
#   `INPUT_MAIL_FILTER()` or `MAIL_FILTER()` macros are used.
#
#
define sendmail::mc::milter (
  Enum['local','unix','inet','inet6'] $socket_type,
  String                              $socket_spec,
  Enum['R','T','4','']                $flags           = 'T',
  Optional[Sendmail::Timeout]         $send_timeout    = undef,
  Optional[Sendmail::Timeout]         $receive_timeout = undef,
  Optional[Sendmail::Timeout]         $eom_timeout     = undef,
  Optional[Sendmail::Timeout]         $connect_timeout = undef,
  String                              $order           = '00',
  String                              $milter_name     = $title,
  Boolean                             $enable          = true,
) {
  include sendmail::mc::milter_section

  #
  # Socket parameter
  #

  case $socket_type {
    /^(local|unix)$/: { assert_type(Stdlib::Absolutepath, $socket_spec) }
    /^inet6?$/: { assert_type(Pattern[/^[0-9]+@./], $socket_spec) }
    default: { fail('Invalid socket type') }
  }

  #
  # Timout parameter
  #

  $sparse_timeouts = {
    'S' => $send_timeout,
    'R' => $receive_timeout,
    'E' => $eom_timeout,
    'C' => $connect_timeout,
  }

  $real_timeouts = $sparse_timeouts.filter |$key,$val| { $val != undef }

  $opt_timeouts = empty($real_timeouts) ? {
    true    => undef,
    default => join(join_keys_to_values($real_timeouts, ':'), ';'),
  }

  #
  # Put everything together
  #

  $sparse_opts_all = {
    'S' => "${socket_type}:${socket_spec}",
    'F' => $flags,
    'T' => $opt_timeouts,
  }

  $real_opts_all = $sparse_opts_all.filter |$key,$val| { $val != undef }

  $opts = join(join_keys_to_values($real_opts_all, '='), ', ')

  #
  # Decide which macro to use
  #
  $macro_name = bool2str($enable, 'INPUT_MAIL_FILTER', 'MAIL_FILTER')

  concat::fragment { "sendmail_mc-milter-${milter_name}":
    target  => 'sendmail.mc',
    order   => "56-${order}",
    content => "${macro_name}(`${milter_name}', `${opts}')dnl\n",
  }
}
