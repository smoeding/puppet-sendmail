# = Define: sendmail::aliases::entry
#
# Create entries in the Sendmail alias file.
#
# == Parameters:
#
# [*recipient*]
#   The recipient where the mail is redirected to.
#
# [*ensure*]
#   Used to create or remove the alias entry.
#   Default: present
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
  $recipient,
  $ensure = present,
) {
  include ::sendmail::params
  include ::sendmail::aliases::file
  include ::sendmail::aliases::newaliases

  mailalias { $name:
    ensure    => $ensure,
    recipient => $recipient,
    notify    => Class['::sendmail::aliases::newaliases'],
    require   => Class['::sendmail::aliases::file'],
  }
}
