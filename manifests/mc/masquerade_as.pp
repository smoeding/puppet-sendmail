# = Define: sendmail::mc::masquerade_as
#
# Add the MASQUERADE_AS macro to the sendmail.mc file.
#
# == Parameters:
#
# [*masquerade_as*]
#   Mail being sent is rewritten as coming from the indicated address.
#
# [*masquerade_envelope*]
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   sendmail::mc::masquerade_as { 'example.com':
#     masquerade_envelope => true,
#   }
#
#
define sendmail::mc::masquerade_as (
  $masquerade_as             = $title,
  $masquerade_domain         = [],
  $masquerade_domain_file    = undef,
  $masquerade_exception      = [],
  $masquerade_exception_file = undef,
  $masquerade_envelope       = false,
  $allmasquerade             = false,
  $limited_masquerade        = false,
  $local_no_masquerade       = false,
  $masquerade_entire_domain  = false,
  $exposed_user              = [],
  $exposed_user_file         = undef,
) {
  include ::sendmail::makeall

  validate_bool($masquerade_envelope)
  validate_bool($allmasquerade)
  validate_bool($limited_masquerade)
  validate_bool($local_no_masquerade)
  validate_bool($masquerade_entire_domain)

  concat::fragment { 'sendmail_mc-masquerade':
    target  => 'sendmail.mc',
    order   => '31',
    content => template('sendmail/masquerade.m4.erb'),
    notify  => Class['::sendmail::makeall'],
  }

}
