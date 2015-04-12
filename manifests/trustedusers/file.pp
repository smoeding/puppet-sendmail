# = Class: sendmail::trustedusers::file
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
#   class { 'sendmail::trustedusers::file': }
#
#
class sendmail::trustedusers::file {
  include ::sendmail::params

  file { $::sendmail::params::trustedusers_file:
    ensure => file,
    owner  => 'root',
    group  => $::sendmail::params::sendmail_group,
    mode   => '0644',
  }
}
