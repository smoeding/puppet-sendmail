# @summary Rebuild the Sendmail aliases file.
#
# This class is notified automatically when an alias is managed using the
# `sendmail::aliases::entry` defined type.
#
# @api private
#
#
class sendmail::aliases::newaliases {
  include sendmail::params

  exec { 'sendmail::aliases::newaliases':
    command     => "${sendmail::params::sendmail_binary} -bi",
    refreshonly => true,
  }
}
