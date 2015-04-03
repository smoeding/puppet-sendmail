# = Class: sendmail::alias::rebuild
#
# Rebuild the Sendmail alias file.
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
#   class { 'sendmail::alias::rebuild': }
#
#
class sendmail::alias::rebuild {
  include ::sendmail::params

  exec { "${::sendmail::params::sendmail_binary} -bi":
    refreshonly => true,
  }
}
