# = Define: sendmail::relaydomains::entry
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
#   sendmail::relaydomains::entry { 'example.com':
#     ensure => present,
#   }
#
#   sendmail::relaydomains::entry { 'example.org':
#     ensure => absent,
#   }
#
#
define sendmail::relaydomains::entry (
  $domain = $name,
  $ensure = 'present',
) {
  include ::sendmail::params
  include ::sendmail::relaydomains::file

  $changes = $ensure ? {
    'present' => "set key[. = '${domain}'] '${domain}'",
    'absent'  => "rm key[. = '${domain}']",
  }

  augeas { "/etc/mail/relay-domains-${domain}":
    lens    => 'Sendmail_List.lns',
    incl    => '/etc/mail/relay-domains',
    changes => $changes,
    require => Class['::sendmail::relaydomains::file'],
  }
}
