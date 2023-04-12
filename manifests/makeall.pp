# @summary Rebuild all config files for the Sendmail MTA using a Makefile
#
# @api privat
#
#
class sendmail::makeall {
  include sendmail::params
  include sendmail::package

  exec { 'sendmail::makeall':
    command     => $sendmail::params::configure_command,
    refreshonly => true,
    path        => '/bin:/sbin:/usr/bin:/usr/sbin',
    require     => Class['sendmail::package'],
    before      => Class['sendmail::service'],
  }
}
