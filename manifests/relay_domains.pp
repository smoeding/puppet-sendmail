# = Class: sendmail::relay_domains
#
# Manage entries in the Sendmail relay-domains file.
#
# == Parameters:
#
# [*relay_domains*]
#   An array of domain names that will be written into the relay domains
#   file. Leading or trailing whitespace is ignored. Empty entries are also
#   ignored. Default value: []
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   class { '::sendmail::relay_domains':
#     relay_domains => [ 'example.com', 'example.net', ],
#   }
#
#
class sendmail::relay_domains (
  Array[String] $relay_domains = [],
) {
  include ::sendmail::params

  file { $::sendmail::params::relay_domains_file:
    ensure  => file,
    owner   => 'root',
    group   => $::sendmail::params::sendmail_group,
    mode    => '0644',
    content => join(suffix(sendmail::canonify_array($relay_domains), "\n")),
    notify  => Class['::sendmail::service'],
  }
}
