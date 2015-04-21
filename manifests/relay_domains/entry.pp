# = Define: sendmail::relay_domains::entry
#
# Create or remove a domain entry in the relay-domains file.
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
#   sendmail::relay_domains::entry { 'example.com':
#     ensure => present,
#   }
#
#   sendmail::relay_domains::entry { 'example.org':
#     ensure => absent,
#   }
#
#
define sendmail::relay_domains::entry (
  $domain = $name,
  $ensure = 'present',
) {
  include ::sendmail::params
  include ::sendmail::relay_domains::file

  $changes = $ensure ? {
    'present' => "set key[. = '${domain}'] '${domain}'",
    'absent'  => "rm key[. = '${domain}']",
  }

  augeas { "${::sendmail::params::relay_domains_file}-${domain}":
    lens    => 'Sendmail_List.lns',
    incl    => $::sendmail::params::relay_domains_file,
    changes => $changes,
    require => Class['::sendmail::relay_domains::file'],
  }
}
