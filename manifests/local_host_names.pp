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
  Array[String] $local_host_names = [],
) {
  include ::sendmail::params

  file { $::sendmail::params::local_host_names_file:
    ensure  => file,
    owner   => 'root',
    group   => $::sendmail::params::sendmail_group,
    mode    => '0644',
    content => join(suffix(sendmail::canonify_array($local_host_names), "\n")),
    notify  => Class['::sendmail::service'],
  }
}
