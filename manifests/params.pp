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

  # File locations
  $sendmail_alias_file          = '/etc/aliases'
  $sendmail_access_file         = "${mail_settings_dir}/access"
  $sendmail_bitdomain_file      = "${mail_settings_dir}/bitdomain"
  $sendmail_domaintable_file    = "${mail_settings_dir}/domaintable"
  $sendmail_genericstable_file  = "${mail_settings_dir}/genericstable"
  $sendmail_localhostnames_file = "${mail_settings_dir}/local-host-names"
  $sendmail_mailertable_file    = "${mail_settings_dir}/mailertable"
  $sendmail_relaydomains_file   = "${mail_settings_dir}/relay-domains"
  $sendmail_trustedusers_file   = "${mail_settings_dir}/trusted-users"
  $sendmail_userdb_file         = "${mail_settings_dir}/userdb"
  $sendmail_uudomain_file       = "${mail_settings_dir}/uudomain"
  $sendmail_virtusertable_file  = "${mail_settings_dir}/virtusertable"

  $sendmail_sendmail_mc_file    = "${mail_settings_dir}/sendmail.mc"
  $sendmail_submit_mc_file      = "${mail_settings_dir}/submit.mc"

  $package_name      = 'sendmail'
  $service_name      = 'sendmail'

  $sendmail_binary   = '/usr/sbin/sendmail'

  $configure_command = 'make -C /etc/mail all'

  $sendmail_smarthost      = $::domain
  $sendmail_masquerade_as  = $::domain

  case $::operatingsystem {

    'Debian': {
      $auxiliary_packages = [ 'bsd-mailx', ]

      # Unfortunately the /etc/init.d/sendmail script does
      # not provide a useful status exit code on wheezy.
      $service_hasstatus = false

      $sendmail_user    = 'smmta'
      $sendmail_group   = 'smmsp'

      $sendmail_ostype  = 'linux'
      $sendmail_include = '/usr/share/sendmail/cf/m4/cf.m4'
    }

    'Redhat': {
      $auxiliary_packages = [ 'sendmail-cf', 'm4', 'make', 'cyrus-sasl', 'mailx', ]

      $service_hasstatus = true

      $sendmail_ostype  = 'linux'
      $sendmail_include = '/usr/share/sendmail-cf/m4/cf.m4'
    }

    default: {
      fail("Unsupported operatingsystem ${::operatingsystem}")
    }
  }
}
