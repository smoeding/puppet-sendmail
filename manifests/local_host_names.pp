# = Class: sendmail::local_host_names
#
# Manage entries in the Sendmail local-host-names file.
#
# == Parameters:
#
# [*local_host_names*]
#   An array of host names that will be written into the local host names
#   file. Leading or trailing whitespace is ignored. Empty entries are also
#   ignored. Default value: []
#
# == Requires:
#
# Nothing.
#
# == Sample Usage:
#
#   class { '::sendmail::local_host_names:
#     local_host_names => [ 'example.org', 'mail.example.org', ],
#   }
#
#
class sendmail::local_host_names (
  $local_host_names = [],
) {
  include ::sendmail::params

  validate_array($local_host_names)

  file { $::sendmail::params::local_host_names_file:
    ensure  => file,
    owner   => 'root',
    group   => $::sendmail::params::sendmail_group,
    mode    => '0644',
    content => inline_template('<%= @local_host_names.reject{ |x| x.to_s.strip.empty? }.sort.map{ |x| "#{x}\n"}.join %>'),
    notify  => Class['::sendmail::service'],
  }
}
