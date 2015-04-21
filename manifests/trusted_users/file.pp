# = Class: sendmail::trusted_users::file
#
# Create the Sendmail trusted-users file.
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
#   class { 'sendmail::trusted_users::file': }
#
#
class sendmail::trusted_users::file {
  include ::sendmail::params

  file { $::sendmail::params::trusted_users_file:
    ensure => file,
    owner  => 'root',
    group  => $::sendmail::params::sendmail_group,
    mode   => '0644',
  }
}
