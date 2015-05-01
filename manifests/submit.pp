# = Class: sendmail::submit
#
# Manage the submit.mc file for the Sendmail MTA.
#
# == Parameters:
#
# [*msp_host*]
#   The host where the message submission program should deliver to. This
#   can be a hostname or IP address. To prevent MX lookups for the host,
#   put it in square brackets (e.g., [hostname]). Delivery to the local
#   host would therefore use either [127.0.0.1] for IPv4 or [IPv6:::1]
#   for IPv6.
#
# [*msp_port*]
#   The port used for the message submission program. Can be a port number
#   (e.g., 25) or the string MSA for delivery to the message submission
#   agent on port 587.
#
# [*masquerade_as*]
#   Activate masquerading for the message submission program.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   class { 'sendmail::submit':
#     msp_port      => '25',
#     masquerade_as => 'example.org',
#   }
#
#
class sendmail::submit (
  $msp_host      = '[127.0.0.1]',
  $msp_port      = 'MSA',
  $masquerade_as = undef,
) inherits sendmail::params {

  validate_re($msp_port, [ '^[0-9]+$', '^MSA$' ], 'msp_port must be a numeric port number or the literal "MSA"')

  file { $::sendmail::params::submit_mc_file:
    ensure  => file,
    owner   => 'root',
    group   => $sendmail::params::sendmail_group,
    mode    => '0644',
    content => template('sendmail/submit.m4.erb'),
    notify  => [ Class['::sendmail::makeall'], Class['::sendmail::service'], ],
  }
}
