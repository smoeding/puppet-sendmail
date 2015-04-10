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

  file { '/etc/mail/trusted-users':
    ensure => file,
    owner  => 'root',
    group  => 'smmsp',
    mode   => '0644',
  }
}
