# = Class: sendmail::trusteduser::create
#
# Create the trusted-users file.
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
#   class { 'sendmail::trusteduser::create': }
#
#
class sendmail::trusteduser::create {
  include ::sendmail::params

  file { '/etc/mail/trusted-users':
    ensure => file,
    owner  => 'smmta',
    group  => 'smmsp',
    mode   => '0640',
  }
}
