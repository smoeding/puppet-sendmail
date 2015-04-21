# = Define: sendmail::local_host_names::entry
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
#   sendmail::local_host_names::entry { 'example.com':
#     ensure => present,
#   }
#
#   sendmail::local_host_names::entry { 'example.org':
#     ensure => absent,
#   }
#
#
define sendmail::local_host_names::entry (
  $domain = $name,
  $ensure = 'present',
) {
  include ::sendmail::params
  include ::sendmail::local_host_names::file

  $changes = $ensure ? {
    'present' => "set key[. = '${domain}'] '${domain}'",
    'absent'  => "rm key[. = '${domain}']",
  }

  augeas { "${::sendmail::params::local_host_names_file}-${domain}":
    lens    => 'Sendmail_List.lns',
    incl    => $::sendmail::params::local_host_names_file,
    changes => $changes,
    require => Class['::sendmail::local_host_names::file'],
  }
}
