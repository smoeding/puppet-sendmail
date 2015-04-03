# = Class: sendmail::files::trustedusers
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
#   class { 'sendmail::files::trustedusers': }
#
#
class sendmail::files::trustedusers {
  include ::sendmail::params

  file { '/etc/mail/trusted-users':
    ensure => file,
    owner  => 'smmta',
    group  => 'smmsp',
    mode   => '0640',
  }
}
