# = Define: sendmail::trusted_users::entry
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
#   sendmail::trusted_users::entry { 'fred':
#     ensure => present,
#   }
#
#   sendmail::trusted_users::entry { 'barney':
#     ensure => absent,
#   }
#
#
define sendmail::trusted_users::entry (
  $user   = $name,
  $ensure = 'present',
) {
  include ::sendmail::params
  include ::sendmail::trusted_users::file

  $changes = $ensure ? {
    'present' => "set key[. = '${user}'] '${user}'",
    'absent'  => "rm key[. = '${user}']",
  }

  augeas { "${::sendmail::params::trusted_users_file}-${user}":
    lens    => 'Sendmail_List.lns',
    incl    => $::sendmail::params::trusted_users_file,
    changes => $changes,
    require => Class['::sendmail::trusted_users::file'],
  }
}
