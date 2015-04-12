# = Define: sendmail::trustedusers::entry
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
#   sendmail::trustedusers::entry { 'fred':
#     ensure => present,
#   }
#
#   sendmail::trustedusers::entry { 'barney':
#     ensure => absent,
#   }
#
#
define sendmail::trustedusers::entry (
  $user   = $name,
  $ensure = 'present',
) {
  include ::sendmail::params
  include ::sendmail::trustedusers::file

  $changes = $ensure ? {
    'present' => "set key[. = '${user}'] '${user}'",
    'absent'  => "rm key[. = '${user}']",
  }

  augeas { "${::sendmail::params::trustedusers_file}-${user}":
    lens    => 'Sendmail_List.lns',
    incl    => $::sendmail::params::trustedusers_file,
    changes => $changes,
    require => Class['::sendmail::trustedusers::file'],
  }
}
