# = Define: sendmail::alias
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
#   sendmail::alias { 'fred':
#     recipient => 'barney@example.org',
#   }
#
#
define sendmail::alias (
  $recipient,
  $ensure = present,
) {
  include ::sendmail::params
  include ::sendmail::files::aliases
  include ::sendmail::files::newaliases

  mailalias { $name:
    ensure    => $ensure,
    recipient => $recipient,
    notify    => Class['::sendmail::files::newaliases'],
    require   => Class['::sendmail::files::aliases'],
  }
}
