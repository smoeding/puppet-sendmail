# = define: sendmail::mc::daemon_options
#
# Add the DAEMON_OPTIONS macro to the sendmail.mc file.
#
# == Parameters:
#
# [*daemon_name*]
#   The name of the daemon to use. The logfile will contain this name to
#   identify the daemon. Default is the resource title.
#
# [*family*]
#   The network family type. Valid options: 'inet', 'inet6' or 'iso'
#
# [*addr*]
#   The network address to listen on for remote connections. This can be
#   a hostname or network address.
#
# [*port*]
#   The port used by the daemon. This can be either a numeric port number
#   or a service name like 'smtp' for port 25.
#
# [*children*]
#   The maximum number of processes to fork for this daemon.
#
# [*delivery_mode*]
#   The mode of delivery for this daemon. Valid options: 'background',
#   'deferred', 'interactive' or 'queueonly'.
#
# [*input_filter*]
#   A list of milters to use. This can either be an array of milter names or
#   a single string, where the milter names are separated by colons.
#
# [*listen*]
#   The length of the listen queue used by the operating system.
#
# [*modify*]
#   Single letter flags to modify the daemon behaviour. See the Sendmail
#   documention for details.
#
# [*delay_la*]
#   The local load average at which connections are delayed before they
#   are accepted.
#
# [*queue_la*]
#   The local load average at which received mail is queued and not
#   delivered immediately.
#
# [*refuse_la*]
#   The local load average at which mail is no longer accepted.
#
# [*send_buf_size*]
#   The size of the network send buffer used by the operating system.
#   The value is a size in bytes.
#
# [*receive_buf_size*]
#   The size of the network receive buffer used by the operating system.
#   The value is a size in bytes.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   sendmail::mc::daemon_options { 'MTA-v4':
#     family => 'inet',
#     port   => '25',
#   }
#
#
define sendmail::mc::daemon_options (
  $daemon_name      = $title,
  $family           = undef,
  $addr             = undef,
  $port             = undef,
  $children         = undef,
  $delivery_mode    = undef,
  $input_filter     = undef,
  $listen           = undef,
  $modify           = undef,
  $delay_la         = undef,
  $queue_la         = undef,
  $refuse_la        = undef,
  $send_buf_size    = undef,
  $receive_buf_size = undef,
) {

  include ::sendmail::makeall

  validate_string($daemon_name)

  if !empty($family) {
    validate_re($family, [ '^inet$', '^inet6$', '^iso$'])
  }

  if !empty($delivery_mode) {
    validate_re($delivery_mode,
      [
        '^b$', '^background$',
        '^d$', '^deferred$',
        '^i$', '^interactive$',
        '^q$', '^queueonly$',
    ])
  }

  $delivery = $delivery_mode ? {
    undef   => undef,
    ''      => undef,
    default => regsubst($delivery_mode, '^(.).*$', '\1')
  }

  # Build string if array has been given
  $filter = is_array($input_filter) ? {
    true    => join($input_filter, ';'),
    default => $input_filter,
  }

  $sparse_opts = [
    "Name=${daemon_name}",
    "Family=${family}",
    "Addr=${addr}",
    "Port=${port}",
    "children=${children}",
    "DeliveryMode=${delivery}",
    "InputFilter=${filter}",
    "Listen=${listen}",
    "M=${modify}",
    "delayLA=${delay_la}",
    "queueLA=${queue_la}",
    "refuseLA=${refuse_la}",
    "SendBufSize=${send_buf_size}",
    "ReceiveBufSize=${receive_buf_size}",
  ]

  # Remove unset options by mapping them to a single '=' and deleting it
  $real_opts = delete(regsubst($sparse_opts, '^.*=$', '='), '=')

  $opts = join($real_opts, ', ')

  concat::fragment { "sendmail_mc-daemon_options-${title}":
    target  => 'sendmail.mc',
    order   => '40',
    content => inline_template("DAEMON_OPTIONS(`${opts}')dnl\n"),
    notify  => Class['::sendmail::makeall'],
  }

  # Also add the section header
  include ::sendmail::mc::macro_section
}
