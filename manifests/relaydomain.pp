# = Define: sendmail::relaydomain
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
#   sendmail::relaydomain { 'example.com':
#     ensure => present,
#   }
#
#   sendmail::relaydomain { 'example.org':
#     ensure => absent,
#   }
#
#
define sendmail::relaydomain (
  $domain = $name,
  $ensure = present,
) {
  include ::sendmail::params
  include ::sendmail::relaydomain::create

  if ($ensure == absent) {
    augeas { "/etc/mail/relay-domains-${domain}":
      lens    => 'Sendmail_List.lns',
      incl    => '/etc/mail/relay-domains',
      changes => "rm key[ . = '${domain}']",
      require => Class['::sendmail::relaydomain::create'],
    }
  }
  else {
    augeas { "/etc/mail/relay-domains-${domain}":
      lens    => 'Sendmail_List.lns',
      incl    => '/etc/mail/relay-domains',
      changes => "set key[ . = '${domain}'] '${domain}'",
      require => Class['::sendmail::relaydomain::create'],
    }
  }
}
