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
  include ::sendmail::alias::create
  include ::sendmail::alias::rebuild

  mailalias { $name:
    ensure    => $ensure,
    recipient => $recipient,
    notify    => Class['::sendmail::alias::rebuild'],
    require   => Class['::sendmail::alias::create'],
  }
}
