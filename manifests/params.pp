# = Class: sendmail::params
#
# The parameters used when setting up the Sendmail MTA.
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
#   include ::sendmail::params
#
#
class sendmail::params {

  # Where (most of) the sendmail configuration files are kept
  $mail_settings_dir = '/etc/mail'

  $package_ensure    = present

  $service_enable    = true
  $service_ensure    = running
  $service_name      = 'sendmail'

  $sendmail_binary   = '/usr/sbin/sendmail'

  $makemap_binary    = '/usr/sbin/makemap'
  $makemap_maptype   = 'hash'

  $sendmail_smarthost      = $::domain
  $sendmail_masquerade_as  = $::domain

  case $::osfamily {

    'Debian': {
      $package_name     = [ 'sendmail', 'bsd-mailx' ]
      $sendmail_user    = 'smmta'
      $sendmail_group   = 'smmsp'
      $sendmail_ostype  = 'linux'
      $sendmail_include = '/usr/share/sendmail/cf/m4/cf.m4'
    }

    'Redhat': {
      $package_name     = [ 'sendmail', 'sendmail-cf', 'cyrus-sasl', 'mailx' ]
      $sendmail_ostype  = 'linux'
      $sendmail_include = '/usr/share/sendmail-cf/m4/cf.m4'
    }

    default: {
      fail("Unsupported osfamily ${::osfamily}")
    }
  }
}
