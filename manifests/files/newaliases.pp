# = Class: sendmail::files::newaliases
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
#   class { 'sendmail::files::newaliases': }
#
#
class sendmail::files::newaliases {
  include ::sendmail::params

  exec { "${::sendmail::params::sendmail_binary} -bi":
    refreshonly => true,
  }
}
