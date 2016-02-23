# = Define: sendmail::mc::milter
#
# Manage Sendmail Milter configuration in sendmail.mc
#
# == Parameters:
#
# [*socket_type*]
#   The type of socket to use for connecting to the milter.
#   Valid values: 'local', 'unix', 'inet', 'inet6'
#
# [*socket_spec*]
#   The socket specification for connecting to the milter. For the type
#   'local' ('unix' is a synonym) this is the full path to the Unix-domain
#   socket. For the 'inet' and 'inet6' type socket this must be the port
#   number, a literal '@' character and the host or address specification.
#
# [*flags*]
#   A single character to specify how milter failures are handled by
#   Sendmail. The letter 'R' rejects the message, a 'T' causes a temporary
#   failure and the character '4' (available with Sendmail V8.4 or later)
#   rejects with a 421 response code.
#
# [*send_timeout*]
#   Timeout when sending data from the MTA to the Milter.
#   Default value: undefined (using the Sendmail default 10sec)
#
# [*receive_timeout*]
#   Timeout when reading a reply from the Milter.
#   Default value: undefined (using the Sendmail default 10sec)
#
# [*eom_timeout*]
#   Overall timeout from sending the messag to Milter until the final
#   end of message reply is received.
#   Default value: undefined (using the Sendmail default 5min)
#
# [*connect_timeout*]
#   Connection timeout
#   Default value: undefined (using the Sendmail default 5min)
#
# [*order*]
#   A string used to determine the order of the mail filters in the
#   configuration file. This also defines the order in which the filters
#   are called.
#   Default value: '00'
#
# [*milter_name*]
#   The name of the milter to create. Defaults to the resource title.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   sendmail::mc::milter { 'greylist':
#     socket_type => 'local',
#     socket_spec => '/var/run/milter-greylist/milter-greylist.sock',
#   }
#
#   sendmail::mc::milter { 'greylist':
#     socket_type => 'inet',
#     socket_spec => '12345@127.0.0.1',
#   }
#
#
define sendmail::mc::milter (
  $socket_type,
  $socket_spec,
  $flags           = 'T',
  $send_timeout    = undef,
  $receive_timeout = undef,
  $eom_timeout     = undef,
  $connect_timeout = undef,
  $order           = '00',
  $milter_name     = $title,
) {

  include ::sendmail::makeall

  #
  # Socket parameter
  #
  if $socket_type != undef {
    case $socket_type {
      /^(local|unix)$/: { validate_absolute_path($socket_spec) }
      /^inet6?$/: { validate_re($socket_spec, '^[0-9]+@.') }
      default: { fail('Invalid socket type') }
    }

    $opt_socket = "${socket_type}:${socket_spec}"
  }
  else {
    $opt_socket = undef
  }

  #
  # Flags parameter
  #
  if $flags {
    validate_re($flags, [ '^R$', '^T$', '^4$' ])

    $opt_flags = $flags
  }
  else {
    $opt_flags = undef
  }

  #
  # Timout parameter
  #
  if $send_timeout {
    validate_re($send_timeout, '^[0-9]+(s|m)?$')
  }
  if $receive_timeout {
    validate_re($receive_timeout, '^[0-9]+(s|m)?$')
  }
  if $eom_timeout {
    validate_re($eom_timeout, '^[0-9]+(s|m)?$')
  }
  if $connect_timeout {
    validate_re($connect_timeout, '^[0-9]+(s|m)?$')
  }

  $sparse_timeouts = [
    "S:${send_timeout}",
    "R:${receive_timeout}",
    "E:${eom_timeout}",
    "C:${connect_timeout}",
  ]

  # Remove unset options
  $real_timeouts = delete(regsubst($sparse_timeouts, '^.*:$', '='), '=')

  if count($real_timeouts) > 0 {
    $opt_timeouts = join($real_timeouts, '; ')
  }
  else {
    $opt_timeouts = undef
  }

  #
  # Put everything together
  #
  $sparse_opts_all = [
    "S=${opt_socket}",
    "F=${opt_flags}",
    "T=${opt_timeouts}",
  ]

  # Remove unset options
  $real_opts_all = delete(regsubst($sparse_opts_all, '^.*=$', '='), '=')

  $opts = join($real_opts_all, ', ')

  concat::fragment { "sendmail_mc-milter-${milter_name}":
    target  => 'sendmail.mc',
    order   => "56-${order}",
    content => inline_template("INPUT_MAIL_FILTER(`${milter_name}', `${opts}')dnl\n"),
    notify  => Class['::sendmail::makeall'],
  }

  # Also add the section header
  include ::sendmail::mc::milter_section
}
