# = Define: sendmail::aliases::entry
#
# Manage an entry in the Sendmail alias file.
#
# == Parameters:
#
# [*recipient*]
#   The recipient where the mail is redirected to.
#
# [*ensure*]
#   Used to create or remove the alias entry.
#   Valid options: 'present', 'absent'. Default: 'present'
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   sendmail::aliases::entry { 'fred':
#     recipient => 'barney@example.org',
#   }
#
#
define sendmail::aliases::entry (
  $recipient = undef,
  $ensure    = 'present',
) {
  include ::sendmail::params
  include ::sendmail::aliases::file
  include ::sendmail::aliases::newaliases

  validate_re($ensure, [ 'present', 'absent' ])

  if ($ensure == 'present' and empty($recipient)) {
    fail('recipient must be set when creating an alias')
  }

  mailalias { $title:
    ensure    => $ensure,
    recipient => $recipient,
    notify    => Class['::sendmail::aliases::newaliases'],
    require   => Class['::sendmail::aliases::file'],
  }
}
