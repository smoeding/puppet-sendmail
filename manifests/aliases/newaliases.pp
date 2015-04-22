# = Class: sendmail::aliases::newaliases
#
# Rebuild the Sendmail aliases file.
#
# == Parameters:
#
# None.
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   class { 'sendmail::aliases::newaliases': }
#
#
class sendmail::aliases::newaliases {
  include ::sendmail::params

  exec { 'sendmail::aliases::newaliases':
    command     => "${::sendmail::params::sendmail_binary} -bi",
    refreshonly => true,
  }
}
