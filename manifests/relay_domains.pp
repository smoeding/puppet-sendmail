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
  $relay_domains = [],
) {
  include ::sendmail::params

  validate_array($relay_domains)

  file { $::sendmail::params::relay_domains_file:
    ensure  => file,
    owner   => 'root',
    group   => $::sendmail::params::sendmail_group,
    mode    => '0644',
    content => inline_template('<%= @relay_domains.reject{ |x| x.to_s.strip.empty? }.sort.map{ |x| "#{x}\n"}.join %>'),
    notify  => Class['::sendmail::service'],
  }
}
