# = Define: sendmail::trusteduser
#
# Create or remove a user entry in the trusted-users file.
#
# == Parameters:
#
# [*user*]
#   The username to add or remove.
#
# [*ensure*]
#   Use *present* to create the entry or *absent* to remove it.
#   Default: present
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   sendmail::trusteduser { 'fred':
#     ensure => present,
#   }
#
#   sendmail::trusteduser { 'barney':
#     ensure => absent,
#   }
#
#
define sendmail::trusteduser (
  $user   = $name,
  $ensure = 'present',
) {
  include ::sendmail::params
  include ::sendmail::trusteduser::create

  $changes = $ensure ? {
    'present' => "set key[. = ${user}'] '${user}'",
    'absent'  => "rm key[. = '${user}']",
  }

  augeas { "/etc/mail/trusted-users-${user}":
    lens    => 'Sendmail_List.lns',
    incl    => '/etc/mail/trusted-users',
    changes => $changes,
    require => Class['::sendmail::trusteduser::create'],
  }
}
