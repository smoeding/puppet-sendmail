# = Define: sendmail::mc::enhdnsbl
#
# Manage enhanced DNS blacklist entries
#
# == Parameters:
#
# [*blacklist*]
#   The DNS name to query the blacklist.
#
# [*reject_message*]
#   The error message used when rejecting a message.
#
# [*allow_temporary_failure*]
#   Determine what happens when a temporary failure of the DNS lookup
#   occurs. The message is accepted when this parameter is set to 'false'
#   (the default). A temporary error is signaled when this is set to 'true'.
#
# [*lookup_result*]
#   Check the DNS lookup for this result. Leave this parameter unset to
#   block the message as long as anything is returned from the lookup.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   sendmail::mc::enhdnsbl { 'dialups.mail-abuse.org':
#     reject_message          => '"550 dial-up site refused"',
#     allow_temporary_failure => true,
#     lookup_result           => '127.0.0.3.',
#   }
#
#
define sendmail::mc::enhdnsbl (
  $blacklist               = $title,
  $reject_message          = undef,
  $allow_temporary_failure = false,
  $lookup_result           = undef,
) {

  validate_bool($allow_temporary_failure)

  # The parameter for temporary_failure must be `t' or empty
  $temporary_failure = $allow_temporary_failure ? {
    true  => 't',
    false => undef,
  }

  # Find out how many commas to separate the parameters we need
  if ($lookup_result != undef) {
    $commas = 4
  }
  elsif ($temporary_failure == 't') {
    $commas = 3
  }
  elsif ($reject_message != undef) {
    $commas = 2
  }
  else {
    $commas = 1
  }

  concat::fragment { "sendmail_mc-enhdnsbl_${blacklist}":
    target  => 'sendmail.mc',
    order   => '51',
    content => template('sendmail/enhdnsbl.m4.erb'),
    notify  => Class['::sendmail::makeall'],
  }

  # Also add the section header
  include ::sendmail::mc::enhdnsbl_section
}
