# = Define: sendmail::localhostnames::entry
#
# Create or remove a domain entry in the local-host-names file.
#
# == Parameters:
#
# [*domain*]
#   The domain name to add or remove.
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
#   sendmail::localhostnames::entry { 'example.com':
#     ensure => present,
#   }
#
#   sendmail::localhostnames::entry { 'example.org':
#     ensure => absent,
#   }
#
#
define sendmail::localhostnames::entry (
  $domain = $name,
  $ensure = 'present',
) {
  include ::sendmail::params
  include ::sendmail::localhostnames::file

  $changes = $ensure ? {
    'present' => "set key[. = '${domain}'] '${domain}'",
    'absent'  => "rm key[. = '${domain}']",
  }

  augeas { "${::sendmail::params::localhostnames_file}-${domain}":
    lens    => 'Sendmail_List.lns',
    incl    => $::sendmail::params::localhostnames_file,
    changes => $changes,
    require => Class['::sendmail::localhostnames::file'],
  }
}
